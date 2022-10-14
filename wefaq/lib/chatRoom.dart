import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:wefaq/service/local_push_notification.dart';
import 'package:http/http.dart' as http;

late User signedInUser;
late String userEmail;
var tokens = [];

class ChatScreen extends StatefulWidget {
  String projectName;

  ChatScreen({
    required this.projectName,
  });
  static const String screenRoute = 'chat_screen';

  @override
  ChatScreenState createState() => ChatScreenState(projectName);
}

class ChatScreenState extends State<ChatScreen> {
  String projectName;
  ChatScreenState(this.projectName);

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  TextEditingController messageTextEditingControlle = TextEditingController();
  TextEditingController dataController = TextEditingController();

  String? messageText;
  var _picurl;
  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get FName => name.first;
  get LName => name.last;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getTokens();
    getTokensOwner();
  }

  File? imageFile;
  ImagePicker _picker = ImagePicker();

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        userEmail = signedInUser.email.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadImageToFirebase(File file) async {
    String fileUrl = '';
    String fileName = imageFile!.path;
    var reference = FirebaseStorage.instance.ref().child('myfiles/$fileName');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
      () => null,
    );
    await taskSnapshot.ref.getDownloadURL().then((value) {
      fileUrl = value;
    });
// print ("Url $fileUrl");
    return fileUrl;
  }

  Future imageFromGallery(BuildContext context) async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });
    Navigator.of(context).pop();
    String imageURL = await uploadImageToFirebase(File(image!.path));
  }

  Future imageFromCamera(BuildContext context) async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(image!.path);
    });
    Navigator.of(context).pop();

    String imageURL = await uploadImageToFirebase(File(image!.path));
  }

  options(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Choose'),
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Gallery"),
                    onTap: () => imageFromGallery(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Camera"),
                    onTap: () => imageFromCamera(context),
                  ),
                ],
              )),
            ));
  }

  Future getTokens() async {
    var fillterd = _firestore
        .collection('AllJoinRequests')
        .where('project_title', isEqualTo: projectName)
        .where('Status', isEqualTo: 'Accepted')
        .snapshots();
    await for (var snapshot in fillterd)
      for (var Request in snapshot.docs) {
        setState(() {
          tokens.add(Request['participant_token']);
        });
      }
  }

  Future getTokensOwner() async {
    var fillterd = _firestore
        .collection("AllProjects")
        .where('project_title', isEqualTo: projectName)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var p in snapshot.docs) {
        setState(() {
          tokens.add(p['token']);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 182, 168, 203),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 70),
            SizedBox(width: 10),
            Text(
              projectName,
              style: TextStyle(color: Colors.grey[800]),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection(projectName + " project")
                    .orderBy(
                      "time",
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  List<MessageLine> messageWidgets = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(221, 81, 122, 140),
                      ),
                    );
                  }
                  var timeH;
                  var timeM;
                  String? dateM;
                  final messages = snapshot.data!.docs.reversed;
                  for (var message in messages) {
                    var messageText = message.get("message");
                    final messageSender = message.get("senderName");
                    final senderEmail = message.get("email");
                    if (message.get("time") != null) {
                      timeH = message.get("time").toDate().hour;
                      timeM = message.get("time").toDate().minute;

                      dateM = DateFormat.yMMMd()
                          .format(message.get("time").toDate());
                    }
                    if (messageText == null) messageText = ' ';
                    final messageWidget = MessageLine(
                        hour: timeH,
                        minute: timeM,
                        text: messageText,
                        sender: messageSender,
                        img: imageFile,
                        isMe: signedInUser.email == senderEmail,
                        date: dateM.toString());
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: GroupedListView<MessageLine, String>(
                      elements: messageWidgets,
                      groupBy: (message) => message.date.toString(),
                      order: GroupedListOrder.DESC,
                      groupSeparatorBuilder: (String groupByValue) => SizedBox(
                          height: 40,
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    groupByValue.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 144, 120, 155),
                                    ),
                                  )))),
                      itemBuilder: (context, MessageLine message) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: message.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            if (message.isMe)
                              Text("You",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 147, 160, 166),
                                  )),
                            if (!message.isMe)
                              Text(message.sender.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 84, 17, 115),
                                  )),
                            Material(
                              elevation: 5,
                              borderRadius: message.isMe
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    )
                                  : BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                              color: message.isMe
                                  ? Colors.grey[200]
                                  : Color.fromARGB(255, 178, 195, 202),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Text(
                                  message.text.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                            if (message.hour != null && message.minute != null)
                              Text(
                                  message.hour.toString() +
                                      ":" +
                                      message.minute.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromARGB(255, 109, 107, 110),
                                  )),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(172, 136, 98, 146),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextEditingControlle,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => options(context),
                          icon: Icon(Icons.add_photo_alternate_outlined),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        messageTextEditingControlle.clear();
                        _firestore.collection(projectName + " project").add({
                          "message": messageText,
                          "senderName": FName + " " + LName,
                          "email": userEmail,
                          "time": FieldValue.serverTimestamp(),
                        });
                        for (int i = 0; i < tokens.length; i++) {
                          sendNotification(
                              FName + ":" + messageText, tokens[i]);
                        }
                      },
                      child: CircleAvatar(
                        // backgroundColor: MyTheme.kAccentColor,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        backgroundColor: Color.fromARGB(255, 182, 168, 203),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine {
  const MessageLine(
      {this.img,
      this.text,
      this.hour,
      this.minute,
      this.sender,
      required this.isMe,
      required this.date});
  final File? img;
  final int? hour;
  final int? minute;
  final String? sender;
  final String? text;
  final String date;
  final bool isMe;
}

void sendNotification(String title, String token) async {
  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
  };

  try {
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAshcbmas:APA91bGwyZZKhGUguFmek5aalqcySgs3oKgJmra4oloSpk715ijWkf4itCOuGZbeWbPBmHWKBpMkddsr1KyEq6uOzZqIubl2eDs7lB815xPnQmXIEErtyG9wpR9Q4rXdzvk4w6BvGQdJ'
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{'title': title, 'body': ''},
              'priority': 'high',
              'data': data,
              'to': '$token'
            }));

    if (response.statusCode == 200) {
      print("Your notificatin is sent");
    } else {
      print("Error");
    }
  } catch (e) {}
}
