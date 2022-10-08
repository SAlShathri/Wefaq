import 'package:flutter/material.dart';
import 'package:wefaq/bottom_bar_custom.dart';
import 'package:wefaq/mapView.dart';
import 'package:wefaq/projectsScreen.dart';
import 'package:wefaq/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Main Stateful Widget Start
class ProjectsTabs extends StatefulWidget {
  @override
  _ListViewTabsState createState() => _ListViewTabsState();
}

class _ListViewTabsState extends State<ProjectsTabs> {
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
            title: Text('Upcoming projects',
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
                    _signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserLogin()));
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
                Tab(text: 'List view'),
                Tab(
                  text: 'Map view ',
                ),
              ],
            ),
          ),
          body: TabBarView(children: [ProjectsListViewPage(), MapSample()]),
          bottomNavigationBar: CustomNavigationBar(
            currentHomeScreen: 1,
            updatePage: () {},
          ),
        ));
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
