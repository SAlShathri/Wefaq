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
            leading: PopupMenuButton(
              tooltip: "Filter by",
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.date_range,
                        color: Color.fromARGB(144, 64, 7, 87)),
                    title: Text(
                      'Created date',
                      style: TextStyle(
                        color: Color.fromARGB(221, 81, 122, 140),
                      ),
                    ),
                    selected: true,
                    selectedTileColor: Color.fromARGB(255, 252, 243, 243),
                  ),
                ),
                const PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.location_on,
                        color: Color.fromARGB(144, 64, 7, 87)),
                    title: Text(
                      'Nearest',
                      style: TextStyle(
                        color: Color.fromARGB(221, 81, 122, 140),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    // do something
                  }),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 145, 124, 178),
            bottom: const TabBar(
              indicatorColor: Color.fromARGB(255, 84, 53, 134),
              indicatorWeight: 6,
              labelStyle: TextStyle(
                  fontSize: 18.0, fontFamily: 'Family Name'), //For Selected tab
              unselectedLabelStyle: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Family Name'), //For Un-selected Tabs
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
