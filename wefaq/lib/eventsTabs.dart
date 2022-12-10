import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/eventsMaps.dart';
import 'package:wefaq/eventsScreen.dart';
import 'package:wefaq/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Main Stateful Widget Start
class EventsTabs extends StatefulWidget {
  @override
  _ListViewTabsState createState() => _ListViewTabsState();
}

class _ListViewTabsState extends State<EventsTabs> {
  @override
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
            title: Text(
              'Upcoming events',
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
                Tab(text: 'List view'),
                Tab(
                  text: 'Map view ',
                ),
              ],
              labelColor: Color.fromARGB(159, 56, 6, 75),
            ),
          ),
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [EventsListViewPage(), MapSampleEvents()]),
          bottomNavigationBar: CustomNavigationBar(
            currentHomeScreen: 3,
            updatePage: () {},
          ),
        ));
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
