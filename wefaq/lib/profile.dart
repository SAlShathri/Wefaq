import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/background.dart';
import 'bottom_bar_custom.dart';
import 'package:wefaq/models/user.dart';

class profileScreen extends StatefulWidget {
  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  @override
  void initState() {
    super.initState();
    getUser();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.uid);
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  var FName;
  var LName;
  var Email;
  Future getUser() async {
    await for (var snapshot
        in FirebaseFirestore.instance.collection('users').snapshots())
      for (var user in snapshot.docs) {
        if (user.data()['Email'] == signedInUser.email)
          setState(() {
            FName = (user.data()['FirstName']);
            LName = (user.data()['LastName']);
            Email = (user.data()['Email']);
          });
      }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
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
        backgroundColor: Color.fromARGB(255, 182, 168, 203),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 4,
        updatePage: () {},
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Background(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 100),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 143, 132, 159), width: 5),
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/PlaceHolder.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 290),
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 159, 185, 185),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        //sprint two :)
                      },
                    ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 180),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("First Name:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(144, 64, 7, 87),
                            fontSize: 19),
                        textAlign: TextAlign.left),
                    alignment: Alignment.topLeft),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text("$FName",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 93, 89, 104),
                                fontSize: 19),
                            textAlign: TextAlign.left),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 164, 192)),
                        ),
                        color: Color.fromARGB(23, 255, 255, 255))),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("Last Name:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(144, 64, 7, 87),
                            fontSize: 19),
                        textAlign: TextAlign.left),
                    alignment: Alignment.topLeft),
                SizedBox(height: 0.90),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text("$LName",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(118, 117, 121, 1),
                                fontSize: 19),
                            textAlign: TextAlign.left),
                        SizedBox(width: 260),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 164, 192)),
                        ),
                        color: Color.fromARGB(23, 255, 255, 255))),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text("Email:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(144, 64, 7, 87),
                            fontSize: 19),
                        textAlign: TextAlign.left),
                    alignment: Alignment.topLeft),
                SizedBox(height: 0.90),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text("$Email",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(118, 117, 121, 1),
                                fontSize: 19),
                            textAlign: TextAlign.left),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 188, 164, 192)),
                        ),
                        color: Color.fromARGB(23, 255, 255, 255))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
