import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/TabScreen.dart';
import 'package:cool_alert/cool_alert.dart';

class PsentJoinRequestListViewPage extends StatefulWidget {
  @override
  _sentRequestListState createState() => _sentRequestListState();
}

class _sentRequestListState extends State<PsentJoinRequestListViewPage> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  var ProjectTitleList = [];

  var status = [];
  var emailP = [];

  var Email = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    getRequests();
    super.initState();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future getRequests() async {
    var fillterd = _firestore
        .collection('AllJoinRequests')
        .where('participant_email', isEqualTo: Email)
        .where('Status', isEqualTo: 'Pending')
        .snapshots();
    await for (var snapshot in fillterd)
      for (var Request in snapshot.docs) {
        setState(() {
          ProjectTitleList.add(Request['project_title']);
          emailP.add(Request['participant_email']);
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
              height: 80,
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Text(
                          "  " + ProjectTitleList[index] + " project ",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(159, 64, 7, 87),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.0,
                            width: 100,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                              color: Color.fromARGB(159, 215, 14, 14),
                            ),
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              'Delete',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialogFunc(context, emailP[index],
                                ProjectTitleList[index]);
                          },
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

showDialogFunc(context, ParticipantEmail, ProjectTitle) {
  CoolAlert.show(
    context: context,
    title: "",
    confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
    confirmBtnText: 'Delete',
    onConfirmBtnTap: () {
      FirebaseFirestore.instance
          .collection('AllJoinRequests')
          .doc(ProjectTitle + '-' + ParticipantEmail)
          .update({
        'Status': 'Request Deleted',
      });
      CoolAlert.show(
        context: context,
        title: "Request for " + ProjectTitle + " has been deleted  ",
        confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
        onConfirmBtnTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Tabs()));
        },
        type: CoolAlertType.success,
        backgroundColor: Color.fromARGB(221, 212, 189, 227),
      );
    },
    type: CoolAlertType.confirm,
    backgroundColor: Color.fromARGB(221, 212, 189, 227),
    text: " Are you sure you want to Delete Request? ",
  );
}
