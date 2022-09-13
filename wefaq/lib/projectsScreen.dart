import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/models/project.dart';
import 'package:wefaq/project_Screen.dart';

// Main Stateful Widget Start
class ProjectsListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ProjectsListViewPage> {
  @override
  void initState() {
    // TODO: implement initState
    getProjects();
    super.initState();
  }

  final _firestore = FirebaseFirestore.instance;
  @override

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
  var TimeList = [];

//get all projects
  Future getProjects() async {
    await for (var snapshot in _firestore
        .collection('projects')
        .orderBy('created', descending: true)
        .snapshots())
      for (var project in snapshot.docs) {
        setState(() {
          nameList.add(project['name']);
          descList.add(project['description']);
          locList.add(project['location']);
          lookingForList.add(project['lookingFor']);
          categoryList.add(project['category']);
          TimeList.add(project['created']);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width
    double width = MediaQuery.of(context).size.width * 0.6;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 145, 124, 178),
          elevation: 30,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),
          ],
          title: Text(
            'Projects',
            style: TextStyle(color: Colors.white),
          ),
          leading: Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 35,
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),

        // Main List View With Builder
        body: Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            itemCount: nameList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // This Will Call When User Click On ListView Item
                  showDialogFunc(
                      context,
                      nameList[index],
                      descList[index],
                      categoryList[index],
                      locList[index],
                      lookingForList[index]);
                },
                // Card Which Holds Layout Of ListView Item
                child: SizedBox(
                  height: 185,
                  child: Card(
                    color: Color.fromARGB(255, 255, 255, 255),
                    //shadowColor: Color.fromARGB(255, 255, 255, 255),
                    //  elevation: 7,

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.account_circle,
                                color: Color.fromARGB(255, 112, 82, 149),
                                size: 52,
                              ),
                              onPressed: () {
                                // do something
                              },
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: TextButton(
                                  child: Text(
                                    'Layan Alwadie ',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 126, 134, 135)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProjectsListViewPage()));
                                  },
                                ))
                          ]),
                          Row(children: <Widget>[
                            Text(
                              "      " + nameList[index] + " ",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(159, 64, 7, 87),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                          Row(
                            children: <Widget>[
                              Text("     "),
                              const Icon(Icons.location_pin,
                                  color: Color.fromARGB(173, 64, 7, 87)),
                              Text(locList[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(221, 81, 122, 140),
                                  ))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("     "),
                              const Icon(
                                Icons.search,
                                color: Color.fromARGB(248, 170, 167, 8),
                                size: 28,
                              ),
                              Text(lookingForList[index],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(221, 79, 128, 151),
                                      fontWeight: FontWeight.normal),
                                  maxLines: 2,
                                  overflow: TextOverflow.clip),
                            ],
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Expanded(
                              child: //Text("                              "),
                                  /*const Icon(
                                    Icons.arrow_downward,
                                    color: Color.fromARGB(255, 58, 44, 130),
                                    size: 28,
                                  ),*/
                                  TextButton(
                            child: Text(
                              '                                     View More ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 90, 46, 144),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProjectsListViewPage()));
                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ), // sc
      ),
    );
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
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            padding: EdgeInsets.all(15),
            height: 400,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(230, 64, 7, 87),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Color.fromARGB(255, 74, 74, 74),
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.location_pin,
                        color: Color.fromARGB(173, 64, 7, 87)),
                    Text(loc,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(230, 64, 7, 87),
                        ))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.search,
                      color: Color.fromARGB(248, 170, 167, 8),
                      size: 25,
                    ),
                    Text(lookingFor,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(230, 64, 7, 87),
                            fontWeight: FontWeight.normal),
                        maxLines: 2,
                        overflow: TextOverflow.clip),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
                Container(
                  // width: 200,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "About Project ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(230, 64, 7, 87),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  // width: 200,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      desc,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 16, color: Color.fromARGB(144, 64, 7, 87)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
                Container(
                  // width: 200,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(230, 64, 7, 87),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  // width: 200,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      category,
                      style: TextStyle(
                          fontSize: 16, color: Color.fromARGB(144, 64, 7, 87)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40.0,
                  width: 100,
                  margin: EdgeInsets.only(top: 10),

                  // width: size.width * 0.5,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: new LinearGradient(colors: [
                        Color.fromARGB(197, 67, 7, 87),
                        Color.fromARGB(195, 117, 45, 141),
                      ])),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Join",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255)),
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(fontWeight: FontWeight.bold ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
