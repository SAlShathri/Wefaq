import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/AcceptedSentJoinRequest.dart';
import 'package:wefaq/DeclinedSentJoinRequest.dart';
import 'package:wefaq/PendingSentJoinRequest.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

// Main Stateful Widget Start
class Tabs extends StatefulWidget {
  @override
  _ListViewTabsState createState() => _ListViewTabsState();
}

class _ListViewTabsState extends State<Tabs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width
    double width = MediaQuery.of(context).size.width * 0.6;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(159, 56, 6, 75),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }),
            title: Text(
              'Sent Join Requests',
              style: TextStyle(
                  color: Color.fromARGB(159, 0, 0, 0),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            bottom: const TabBar(
              indicatorColor: Color.fromARGB(159, 56, 6, 75),
              indicatorWeight: 6,
              labelStyle: TextStyle(
                  fontSize: 18.0, fontFamily: 'Family Name'), //For Selected tab
              unselectedLabelStyle: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Family Name'), //For Un-selected Tabs
              tabs: [
                Tab(
                  text: 'Pending ',
                ),
                Tab(text: 'Accepted'),
                Tab(
                  text: 'Decliend',
                ),
              ],
              labelColor: Color.fromARGB(159, 56, 6, 75),
            ),
          ),
          body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            PsentJoinRequestListViewPage(),
            AsentJoinRequestListViewPage(),
            DsentJoinRequestListViewPage()
          ]),
          bottomNavigationBar: CustomNavigationBar(
            currentHomeScreen: 0,
            updatePage: () {},
          ),
        ));
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
