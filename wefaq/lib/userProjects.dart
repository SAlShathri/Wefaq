import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/screens/detail_screens/projectDetail.dart';

import 'UserLogin.dart';

// Main Stateful Widget Start
class userProjects extends StatefulWidget {
  String userEmail;
  userProjects({required this.userEmail});

  ListViewPageState createState() => ListViewPageState(this.userEmail);
}

class ListViewPageState extends State<userProjects> {
  String userEmail;
  ListViewPageState(this.userEmail);

  @override
  void initState() {
    getCurrentUser();
    getProjects();

    super.initState();
  }

  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User signedInUser;

  // Title list
  List<String> nameList = [];

  List<String> joiningAs = [];

  String? Email;
  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        Email = signedInUser.email;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //get all projects
  Future getProjects() async {
    await for (var snapshot in _firestore
        .collection("AllJoinRequests")
        .where("participant_email", isEqualTo: userEmail)
        .where("Status", isEqualTo: "Accepted")
        .snapshots())
      for (var r in snapshot.docs) {
        setState(() {
          nameList.add(r['project_title']);
          joiningAs.add(r["joiningAs"]);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width

    return Column(
      children: [
        Expanded(
          child: Scaffold(
            // Main List View With Builder
            body: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                //itemCount: tokens.length,

                itemBuilder: (context, index) {
                  // Card Which Holds Layout Of ListView Item

                  return SizedBox(
                    height: 100,
                    child: GestureDetector(
                        child: Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          //shadowColor: Color.fromARGB(255, 255, 255, 255),
                          //  elevation: 7,

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Row(children: <Widget>[
                                      Text(
                                        "      " + nameList[index] + " ",
                                        style: const TextStyle(
                                          fontSize: 19,
                                          color:
                                              Color.fromARGB(212, 82, 10, 111),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 240,
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      const Text("     "),
                                      const Icon(Icons.person,
                                          color:
                                              Color.fromARGB(173, 64, 7, 87)),
                                      Text(joiningAs[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 34, 94, 120),
                                          )),
                                      Expanded(
                                          child: SizedBox(
                                        width: 100,
                                      )),
                                      IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color.fromARGB(
                                                255, 170, 169, 179),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        projectDetail(
                                                            projecName:
                                                                nameList[index],
                                                            email: userEmail)));
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => projectDetail(
                                      projecName: nameList[index],
                                      email: userEmail)));
                        }),
                  );
                },
                itemCount: nameList.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

showDialogFunc(context) {
  CoolAlert.show(
    context: context,
    title: "",
    confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
    confirmBtnText: 'log out ',
    onConfirmBtnTap: () {
      _signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserLogin()));
    },
    type: CoolAlertType.confirm,
    backgroundColor: Color.fromARGB(221, 212, 189, 227),
    text: "Are you sure you want to log out?",
  );
}
