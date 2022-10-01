import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/projectsScreen.dart';
import 'bottom_bar_custom.dart';
import 'package:cool_alert/cool_alert.dart';

class RequestListViewPageProject extends StatefulWidget {
  @override
  _RequestListProject createState() => _RequestListProject();
}

final _formKey = GlobalKey<FormState>();

class _RequestListProject extends State<RequestListViewPageProject> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController? _searchEditingController = TextEditingController();
  var ProjectTitleListController = [];

  List<String> options = [];
  String? selectedOp;
  var ProjectTitleList = [];
  var ProjectTitleListForDisplay = [];
  var ParticipantNoteList = [];
  var ParticipantEmailList = [];
  var ParticipantjoiningAsList = [];
  var ParticipantNameList = [];
  var tokens = [];

  String? Email;
  @override
  void initState() {
    getCurrentUser();
    getRequests();

    super.initState();
  }

  //----

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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

//          .where('participant_email', isNotEqualTo: Email)
  //get all requests
  Future getRequests() async {
    setState(() {
      ProjectTitleList = [];
      ParticipantEmailList = [];
      ParticipantNameList = [];
      tokens = [];
    });
    if (Email != null) {
      var fillterd = _firestore
          .collection('joinRequests')
          .where('owner_email', isEqualTo: Email)
          .where('Status', isEqualTo: 'Pending')
          .orderBy('project_title')
          .snapshots();
      await for (var snapshot in fillterd)
        for (var Request in snapshot.docs) {
          setState(() {
            ProjectTitleList.add(Request['project_title']);
            ParticipantEmailList.add(Request['participant_email']);
            ParticipantNameList.add(Request['participant_name']);
            ParticipantjoiningAsList.add(Request['joiningAs']);
            //ParticipantNoteList.add(Request['ParticipantNote']);
            tokens.add(Request['participant_token']);
          });
        }
    }
  }

  Future getProjectTitle(String title) async {
    if (title == "") return;
    if (ProjectTitleList.where((element) => element == (title)).isEmpty) {
      CoolAlert.show(
        context: context,
        title: "No such project title!",
        confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
        onConfirmBtnTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RequestListViewPageProject()));
        },
        type: CoolAlertType.error,
        backgroundColor: Color.fromARGB(221, 212, 189, 227),
        text:
            "Please search for a valid project title, valid categories are specified in the drop-down menu below",
      );
      return;
    }

    setState(() {
      ProjectTitleList = [];
      ParticipantEmailList = [];
      ParticipantNameList = [];
      tokens = [];
    });
    var fillterd = _firestore
        .collection('joinRequests')
        .where('owner_email', isEqualTo: Email)
        .where('Status', isEqualTo: 'Pending')
        .where('project_title', isEqualTo: title)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var Request in snapshot.docs) {
        setState(() {
          ProjectTitleList.add(Request['project_title']);
          ParticipantEmailList.add(Request['participant_email']);
          ParticipantNameList.add(Request['participant_name']);
          ParticipantjoiningAsList.add(Request['joiningAs']);
          //ParticipantNoteList.add(Request['ParticipantNote']);
          tokens.add(Request['participant_token']);
        });
      }
  }

  _searchBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: TextFormField(
            controller: _searchEditingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Colors.black87, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Color.fromARGB(144, 64, 7, 87),
                ),
              ),
              labelText: "search for project title",
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    getProjectTitle(_searchEditingController!.text);
                  });
                },
              ),
              suffixIcon: _searchEditingController!.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          getRequests();

                          _searchEditingController?.clear();
                        });
                      },
                    )
                  : null,

              //    suffixIcon :IconButton(
              //                onPressed: () {
              //                setState(() {
              //               // _searchEditingController.clear();
              //            });
              //        },
              //      icon: Icon(Icons.clear_outlined),
              //  )
            ),
            onChanged: (text) {
              setState(() {});
              ProjectTitleListController = ProjectTitleList;
            },
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: _searchEditingController!.text.isEmpty
              ? 0
              : ProjectTitleListController.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 40),
              visualDensity: VisualDensity(vertical: -4),
              //leading: CircleAvatar(
              //  backgroundColor: Color.fromARGB(221, 137, 171, 187),
              // child: Icon(
              //    Icons.category_rounded,
              //    color: Colors.white,
              //  ),
              //  ),
              title: Text(
                ProjectTitleList[index].toString(),
              ),
              onTap: () {
                setState(() {
                  _searchEditingController?.text =
                      ProjectTitleListController[index].toString();
                  ProjectTitleListController = [];
                });
              },
            );
          },
          separatorBuilder: (context, index) {
            //<-- SEE HERE
            return Divider(
              thickness: 0,
              color: Color.fromARGB(255, 194, 195, 194),
            );
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(tokens);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
        title: Text('Received Join Requests',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                _signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
              }),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: ProjectTitleList.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 400,
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
                              Expanded(
                                flex: 3,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.account_circle,
                                    color: Color.fromARGB(255, 112, 82, 149),
                                    size: 52,
                                  ),
                                  onPressed: () {
                                    // go to participant's profile
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "   " + ProjectTitleList[index],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Color.fromARGB(159, 32, 3, 43),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ]),
                            Row(children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Text(
                                  " Joining As:  " +
                                      ParticipantjoiningAsList[index],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Color.fromARGB(159, 32, 3, 43),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ]),
                            DropdownButtonFormField(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              hint: RichText(
                                text: TextSpan(
                                    text: 'Accepting As',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(144, 64, 7, 87)),
                                    children: [
                                      TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ))
                                    ]),
                              ),
                              items: options
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedOp = value as String?;
                                });
                              },
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Color.fromARGB(221, 137, 171, 187),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(144, 64, 7, 87),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value == " ") {
                                  return 'required';
                                }
                              },
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 80),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // if (_formKey.currentState!.validate()) {
                                      FirebaseFirestore.instance
                                          .collection('joinRequests')
                                          .doc(ProjectTitleList[index] +
                                              '-' +
                                              ParticipantEmailList[index])
                                          .update({'Status': 'Accepted'});
                                      FirebaseFirestore.instance
                                          .collection('joinRequests')
                                          .doc(ProjectTitleList[index] +
                                              '-' +
                                              ParticipantEmailList[index])
                                          .update(
                                              {'Participant_role': selectedOp});
                                      CoolAlert.show(
                                          context: context,
                                          title: "Success!",
                                          confirmBtnColor:
                                              Color.fromARGB(144, 64, 6, 87),
                                          type: CoolAlertType.success,
                                          backgroundColor: Color.fromARGB(
                                              221, 212, 189, 227),
                                          text: "You have accepted " +
                                              ParticipantNameList[index] +
                                              " to be part of your team.",
                                          confirmBtnText: 'Done',
                                          onConfirmBtnTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RequestListViewPageProject()));
                                          });
                                      // }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      surfaceTintColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80.0)),
                                      padding: const EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40.0,
                                      width: 100,
                                      decoration: new BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9.0),
                                          gradient: new LinearGradient(colors: [
                                            Color.fromARGB(144, 7, 133, 57),
                                            Color.fromARGB(144, 7, 133, 57),
                                          ])),
                                      padding: const EdgeInsets.all(0),
                                      child: Text(
                                        "Accept",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                  ),
                                ),
                                Text("     "),
                                ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('joinRequests')
                                        .doc(ProjectTitleList[index] +
                                            '-' +
                                            ParticipantEmailList[index])
                                        .update({'Status': 'Declined'});
                                    CoolAlert.show(
                                        context: context,
                                        title: "Success!",
                                        confirmBtnColor:
                                            Color.fromARGB(144, 64, 6, 87),
                                        type: CoolAlertType.success,
                                        backgroundColor:
                                            Color.fromARGB(221, 212, 189, 227),
                                        text: "You have rejected " +
                                            ParticipantNameList[index] +
                                            ", hope you find a better match.",
                                        confirmBtnText: 'Done',
                                        onConfirmBtnTap: () {
                                          // if (ProjectTitleList.length == 1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RequestListViewPageProject()));
                                          // } else {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) =>
                                          //               RequestListViewPage(
                                          //                 projectName:
                                          //                     projectName,
                                          //               )));
                                          // }
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    surfaceTintColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40.0,
                                    width: 100,
                                    decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        gradient: new LinearGradient(colors: [
                                          Color.fromARGB(144, 210, 2, 2),
                                          Color.fromARGB(144, 210, 2, 2)
                                        ])),
                                    padding: const EdgeInsets.all(0),
                                    child: Text(
                                      "Decline",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
