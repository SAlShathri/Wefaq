import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/userProjects.dart';
import 'package:wefaq/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ownerProjects.dart';

// Main Stateful Widget Start
class userProjectsTabs extends StatefulWidget {
  String userEmail;
  userProjectsTabs({required this.userEmail});

  @override
  _ListViewTabsState createState() => _ListViewTabsState(this.userEmail);
}

class _ListViewTabsState extends State<userProjectsTabs> {
  @override
  String userEmail;
  _ListViewTabsState(this.userEmail);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width
    double width = MediaQuery.of(context).size.width * 0.6;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text('Projects',
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
                    showDialogFunc2(context);
                  }),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 145, 124, 178),
            bottom: const TabBar(
              indicatorColor: Color.fromARGB(255, 84, 53, 134),
              indicatorWeight: 6,
              labelStyle: TextStyle(fontSize: 17.0, fontFamily: 'Family Name'),
              unselectedLabelStyle:
                  TextStyle(fontSize: 15.0, fontFamily: 'Family Name'),
              tabs: [
                Tab(text: 'participated Projects'),
                Tab(
                  text: 'Owned projects',
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            userProjects(
              userEmail: userEmail,
            ),
            owneruserProjects(
              userEmail: userEmail,
            )
          ]),
          bottomNavigationBar: CustomNavigationBar(
            currentHomeScreen: 1,
            updatePage: () {},
          ),
        ));
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
          context, MaterialPageRoute(builder: (context) => UserLogin()));
    },
    type: CoolAlertType.confirm,
    backgroundColor: Color.fromARGB(221, 212, 189, 227),
    text: "Are you sure you want to log out?",
  );
}
