import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/eventsScreen.dart';
import 'package:wefaq/models/project.dart';
import 'package:wefaq/projectsScreen.dart';
import 'package:wefaq/userLogin.dart';

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
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserLogin()));
                  }),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 182, 168, 203),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Projects'),
                Tab(
                  text: 'Events',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [ProjectsListViewPage(), EventsListViewPage()],
          ),
          bottomNavigationBar: CustomNavigationBar(
            currentHomeScreen: 0,
            updatePage: () {},
          ),
        ));
  }
}
