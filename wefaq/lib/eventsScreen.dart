import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/models/project.dart';
import 'package:wefaq/profile.dart';
import 'package:favorite_button/favorite_button.dart';

// Main Stateful Widget Start
class EventsListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<EventsListViewPage> {
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

  //url list
  //var urlList = [];

  //category list
  var categoryList = [];

  //category list
  var dateTimeList = [];

  var TimeList = [];
//get all projects
  Future getProjects() async {
    await for (var snapshot in _firestore
        .collection('events')
        .orderBy('created', descending: true)
        .snapshots())
      for (var events in snapshot.docs) {
        setState(() {
          nameList.add(events['name']);
          descList.add(events['description']);
          locList.add(events['location']);
          // urlList.add(events['regstretion url ']);
          categoryList.add(events['category']);
          dateTimeList.add(events['date']);
          TimeList.add(events['time']);

          //  dateTimeList.add(project['dateTime ']);
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
<<<<<<< Updated upstream
                  height: 200,
=======
                  height: 150,
>>>>>>> Stashed changes
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
<<<<<<< Updated upstream
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
                                height: 0,
                              ),
                              /*Row(
                                children: <Widget>[
                                  const Icon(Icons.timelapse_rounded,
                                      color: Color.fromARGB(248, 170, 167, 8)),
                                  Text(dateTimeList[index].toDate().toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(221, 81, 122, 140),
                                          fontWeight: FontWeight.bold))
                                ],
                              ),*/
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.add_link_outlined,
                                    color: Color.fromARGB(248, 170, 167, 8),
                                    size: 28,
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  221, 79, 128, 151),
                                              fontWeight: FontWeight.normal),
                                          text: "  " + urlList[index],
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              u = urlList[index];
                                              if (await canLaunchUrl(u)) {
                                                await launch(u);
                                              } else {
                                                throw 'can not load URL';
                                              }
                                            }),
                                    ]),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(Icons.date_range,
                                      color: Color.fromARGB(144, 64, 7, 87)),
                                  Text(dateTimeList[index],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(221, 81, 122, 140),
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(Icons.timelapse,
                                      color: Color.fromARGB(144, 64, 7, 87)),
                                  Text(TimeList[index],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(221, 81, 122, 140),
                                          fontWeight: FontWeight.bold))
                                ],
=======
                    //shadowColor: Color.fromARGB(255, 255, 255, 255),
                    //  elevation: 7,

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                          SizedBox(
                            height: 7,
                          ),
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
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Text("     "),
                              const Icon(
                                Icons.timelapse_outlined,
                                color: Color.fromARGB(248, 170, 167, 8),
                                size: 21,
>>>>>>> Stashed changes
                              ),
                            ],
                          ),
<<<<<<< Updated upstream
                        )
                      ],
=======
                          SizedBox(
                            height: 0,
                          ),
                          Row(children: <Widget>[
                            //Text("                              "),
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
                                        builder: (context) => showDialogFunc(
                                              context,
                                              nameList[index],
                                              descList[index],
                                              categoryList[index],
                                              locList[index],
                                              dateTimeList[index],
                                              TimeList[index],
                                            )));
                              },
                            ),
                            Text('                  '),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.star_border),
                            )
                          ])
                        ],
                      ),
>>>>>>> Stashed changes
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
showDialogFunc(context, title, desc, category, loc, date, time) {
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
                      Icons.timelapse_outlined,
                      color: Color.fromARGB(248, 170, 167, 8),
                      size: 28,
                    ),
                    Text(date,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(221, 79, 128, 151),
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
                      "About Event ",
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
