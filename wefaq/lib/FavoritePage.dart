import 'package:cloud_firestore/cloud_firestore.dart';
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
  //var latList = [];

  //var lngList = [];
  //List<String> creatDate = [];

  var ownerEmail = [];
  var EventName = [];

  String? Email;
  @override
  void initState() {
    getCurrentUser();

    getFavoriteEvent();
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //get all projects
  Future getFavoriteEvent() async {
    setState(() {
      nameList = [];
      descList = [];
      locList = [];
      urlList = [];
      categoryList = [];
      dateTimeList = [];
      TimeList = [];
      //latList = [];
      //lngList = [];
      //creatDate = [];
      ownerEmail = [];
      EventName = [];
    });
    if (Email != null) {
      var fillterd = _firestore
          .collection('FavoriteEvent')
          .where('favoriteEmail', isEqualTo: Email)
          .orderBy('date', descending: true)
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
            // latList.add(events['lat']);
            // lngList.add(events['lng']);
            // creatDate.add(events['cdate']);
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
                _signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserLogin()));
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
                                    color: Color.fromARGB(212, 82, 10, 111),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: 240,
                                  ),
                                ),
                                /* Text(
                                          creatDate[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 170, 169, 179),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),*/
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
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color.fromARGB(255, 170, 169, 179),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  eventDetailScreen(
                                                    eventName: nameList[index],
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
          // itemCount:_textEditingController!.text.isNotEmpty? nameListsearch.length  : nameListsearch.length,
        ),
      ),
    );
  }
}
