import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserLogin.dart';
import 'bottom_bar_custom.dart';
import 'package:wefaq/screens/detail_screens/event_detail_screen.dart';

class favoritePage extends StatefulWidget {
  @override
  _favoritePageState createState() => _favoritePageState();
}

class _favoritePageState extends State<favoritePage> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  // Title list
  var nameList = [];

  // Description list
  var descList = [];

  // location list
  var locList = [];

  //url list
  var urlList = [];

  //category list
  var categoryList = [];

  //category list
  var dateTimeList = [];

  var TimeList = [];


  var ownerEmail = [];
  var EventName = [];
  var status = [];
  String? Email;
  @override
  void initState() {
    getCurrentUser();

    getFavoriteEvents();
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
  Future getFavoriteEvents() async {
    setState(() {
      nameList = [];
      descList = [];
      locList = [];
      urlList = [];
      categoryList = [];
      dateTimeList = [];
      TimeList = [];
      ownerEmail = [];
      EventName = [];
      status = [];
    });
    if (Email != null) {
      var fillterd = _firestore
          .collection('FavoriteEvents')
          .where('favoriteEmail', isEqualTo: Email)
          .orderBy('date', descending: false)
          .snapshots();
      await for (var snapshot in fillterd)
        for (var events in snapshot.docs) {
          setState(() {
            nameList.add(events['eventName']);
            descList.add(events['description']);
            locList.add(events['location']);
            urlList.add(events['URL']);
            categoryList.add(events['category']);
            dateTimeList.add(events['date']);
            TimeList.add(events['time']);
            EventName.add(events['eventName']);
            ownerEmail.add(events['ownerEmail']);
            status.add(events['status']);
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                showDialogFunc2(context);
              }),
        ],
        title: Text('Favorite events',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 0,
        updatePage: () {},
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemBuilder: (context, index) {
            // Card Which Holds Layout Of ListView Item

            return SizedBox(
              height: 100,
              child: GestureDetector(
                  child: Card(
                    color: status[index] == "Active"
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Color.fromARGB(225, 188, 189, 190),
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
                                    color: Color.fromARGB(211, 90, 12, 121),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                    child: SizedBox(
                                  width: 100,
                                )),
                                if (status[index] == "inactive")
                                  Text(
                                    "Deleted  ",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(210, 193, 23, 23),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),                               
                              ]),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                const Text("     "),
                                const Icon(Icons.location_pin,
                                    color: Color.fromARGB(173, 64, 7, 87)),
                                Text(locList[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 34, 94, 120),
                                    )),
                                Expanded(
                                    child: SizedBox(
                                  width: 100,
                                )),
                                if (status[index] == "Active")
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color:
                                            Color.fromARGB(255, 170, 169, 179),
                                      ),
                                      onPressed: () {
                                        if (status[index] == "Active")
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      eventDetailScreen(
                                                        eventName:
                                                            nameList[index],
                                                      )));
                                      }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    if (status[index] == "Active")
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => eventDetailScreen(
                                    eventName: nameList[index],
                                  )));
                  }),
            );
          },
          itemCount: nameList.length,
        ),
      ),
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

showDialogFunc2(context) {
   CoolAlert.show(
                          context: context,
                          title: "",
                          confirmBtnColor: Color.fromARGB(144, 210, 2, 2),
                          confirmBtnText: 'log out ',
                             onConfirmBtnTap: () {
                
                           _signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserLogin()));
                              
                          },
                    
                          type: CoolAlertType.confirm,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          text:
                              "Are you sure you want to log out?",
                        );
  
}
