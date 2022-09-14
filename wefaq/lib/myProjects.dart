import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/background.dart';
import 'bottom_bar_custom.dart';
import 'package:wefaq/models/user.dart';

class myProjects extends StatefulWidget {
  @override
  _myProjectState createState() => _myProjectState();
}

class _myProjectState extends State<myProjects> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  // Title list
  var nameList = [];

  // Description list
  var descList = [];

  // location list
  var locList = [];

  //Looking for list
  var lookingForList = [];

  //category list
  var categoryList = [];

  String? Email;
  @override
  void initState() {
    getCurrentUser();

    getProjects();
    super.initState();
  }

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
    if (Email != null) {
      var fillterd = _firestore
          .collection('projects')
          .where('email', isEqualTo: Email)
          .orderBy('created', descending: true)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var project in snapshot.docs) {
          setState(() {
            nameList.add(project['name']);
            descList.add(project['description']);
            locList.add(project['location']);
            lookingForList.add(project['lookingFor']);
            categoryList.add(project['category']);
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 182, 168, 203),
        title: Text('My projects',
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
                //-----------------------------------------------
                _signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
              }),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 1,
        updatePage: () {},
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: nameList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // This Will Call When User Click On ListView Item
                showDialogFunc(context, nameList[index], descList[index]);
              },
              // Card Which Holds Layout Of ListView Item
              child: SizedBox(
                height: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                  shadowColor: Color.fromARGB(255, 0, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Text(
                                " " + nameList[index] + " | ",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Color.fromARGB(144, 64, 7, 87),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                categoryList[index],
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 23,
                                  color: Color.fromARGB(144, 64, 7, 87),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.location_pin,
                                    color: Color.fromARGB(144, 64, 7, 87)),
                                Text(locList[index],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(221, 81, 122, 140),
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.search,
                                  color: Color.fromARGB(248, 170, 167, 8),
                                  size: 28,
                                ),
                                Text("Looking For: " + lookingForList[index],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(221, 81, 122, 140),
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 290),
                              child: IconButton(
                                onPressed: () => {},
                                icon: Icon(
                                  Icons.done_rounded,
                                  color: Colors.lightGreen,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                      Expanded(
                          child: //Text("                              "),
                              /*const Icon(
                                    Icons.arrow_downward,
                                    color: Color.fromARGB(255, 58, 44, 130),
                                    size: 28,
                                  ),*/
                              TextButton(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'View More',
                            style: TextStyle(
                              color: Color.fromARGB(255, 90, 46, 144),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialogFunc(
                              context,
                              nameList[index],
                              descList[index],
                              categoryList[index],
                              locList[index],
                              lookingForList[index]);
                        },
                      ))
                    ],
>>>>>>> 88c555775828118088bd7ddd1da29adcb72aea20
                  ),
                ),
              ),
            );
          },
        ),
      ), // sc
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

// This is a block of Model Dialog
showDialogFunc(context, title, desc, category, loc, lookingFor) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            padding: EdgeInsets.all(15),
            height: 300,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(144, 64, 7, 87),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  // width: 200,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      desc,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(144, 64, 7, 87)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                /*Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 290),
                      child: ElevatedButton.icon(
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectsListViewPage()))
                        },
                        icon:
                            Icon(Icons.cancel), //icon data for elevated button
                        label: Text("  "), //label text
                      )),
                ),*/
              ],
            ),
          ),
        ),
      );
    },
  );
}
