import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'bottom_bar_custom.dart';

class DsentJoinRequestListViewPage extends StatefulWidget {
  @override
  _sentRequestListState createState() => _sentRequestListState();
}

class _sentRequestListState extends State<DsentJoinRequestListViewPage> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = [];

  var status = [];

  var Email = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    getRequests();
    super.initState();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //get all projects
  Future getRequests() async {
    var fillterd = _firestore
        .collection('joinRequests')
        .where('participant_email', isEqualTo: Email)
        .where('Status', isEqualTo: "Declined")
        .snapshots();
    await for (var snapshot in fillterd)
      for (var Request in snapshot.docs) {
        setState(() {
          ProjectTitleList.add(Request['project_title']);
          status.add(Request['Status']);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: ProjectTitleList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 100,
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Row(children: <Widget>[
                        Text(
                          "Your request to join ",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(159, 64, 7, 87),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          width: 100,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                              color: Color.fromARGB(144, 210, 2, 2)),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            status[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ]),
                      Row(children: <Widget>[
                        Text(
                          ProjectTitleList[index] + " project is ",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(159, 64, 7, 87),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
