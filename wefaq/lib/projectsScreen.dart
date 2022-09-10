import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/models/project.dart';

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
            backgroundColor: Color.fromARGB(221, 137, 171, 187),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Projects'),
                Tab(
                  text: 'Events',
                ),
              ],
            )),
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
                  showDialogFunc(context, nameList[index], descList[index]);
                },
                // Card Which Holds Layout Of ListView Item
                child: SizedBox(
                  height: 200,
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Text(
                                  nameList[index] + " | ",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromARGB(144, 64, 7, 87),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  categoryList[index],
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 25,
                                    color: Color.fromARGB(144, 64, 7, 87),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(Icons.location_pin,
                                      color: Color.fromARGB(144, 64, 7, 87)),
                                  Text(locList[index],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              221, 137, 171, 187),
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(Icons.warning_sharp,
                                      color: Color.fromARGB(144, 181, 179, 26)),
                                  Text("Looking For ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              221, 137, 171, 187),
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Expanded(
                                child: Text(" " + lookingForList[index],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(221, 137, 171, 187),
                                        fontWeight: FontWeight.normal)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 290),
                                  child: ElevatedButton(
                                    onPressed: () => {},
                                    child: Text('Join',
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(144, 64, 7, 87),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}

// This is a block of Model Dialog
showDialogFunc(context, title, desc) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
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
                    alignment: Alignment.center,
                    child: Text(
                      desc,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(144, 64, 7, 87)),
                      textAlign: TextAlign.center,
                    ),
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
