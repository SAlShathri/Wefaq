import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get FName => name.first;
  get LName => name.last;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

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

                  final messages = snapshot.data!.docs.reversed;
                  for (var message in messages) {
                    final messageText = message.get("message");
                    final messageSender = message.get("senderName");
                    final senderEmail = message.get("email");

                    final messageWidget = MessageLine(
                      text: messageText,
                      sender: messageSender,
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
  const MessageLine({this.text, this.sender, required this.isMe, super.key});
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
          Text("$sender",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
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
        ],
      ),
    );
  }
}
