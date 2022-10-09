import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wefaq/chatDetails.dart';

late User signedInUser;
late String userEmail;

class ChatScreen extends StatefulWidget {
  String projectName;
  ChatScreen({required this.projectName});
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

  String? messageText;
  var _picurl;
  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get FName => name.first;
  get LName => name.last;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
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

  Future imageFromGallery(BuildContext context) async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });
    Navigator.of(context).pop();
  }

  Future imageFromCamera(BuildContext context) async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(image!.path);
    });
    Navigator.of(context).pop();
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
        actions: [],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection(projectName + " project")
                    .orderBy("time")
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
                  final messages = snapshot.data!.docs.reversed;
                  for (var message in messages) {
                    var messageText = message.get("message");
                    final messageSender = message.get("senderName");
                    final senderEmail = message.get("email");
                    if (message.get("time") != null) {
                      timeH = message.get("time").toDate().hour;
                      timeM = message.get("time").toDate().minute;
                    }
                    if (messageText == null) messageText = ' ';
                    final messageWidget = MessageLine(
                      hour: timeH,
                      minute: timeM,
                      text: messageText,
                      sender: messageSender,
                      img: imageFile,
                      isMe: signedInUser.email == senderEmail,
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageWidgets,
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

class MessageLine extends StatelessWidget {
  const MessageLine(
      {this.img,
      this.text,
      this.hour,
      this.minute,
      this.sender,
      required this.isMe,
      super.key});
  final File? img;
  final int? hour;
  final int? minute;
  final String? sender;
  final String? text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          if (isMe)
            Text("You",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 147, 160, 166),
                )),
          if (!isMe)
            Text("$sender",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 84, 17, 115),
                )),
          Material(
            elevation: 5,
            borderRadius: isMe
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
            color: isMe ? Colors.grey[200] : Color.fromARGB(255, 178, 195, 202),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                "$text",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          if (hour != null && minute != null)
            Text(" $hour:$minute",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 109, 107, 110),
                )),
        ],
      ),
    );
  }
}
