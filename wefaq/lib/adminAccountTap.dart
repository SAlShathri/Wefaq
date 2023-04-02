import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/AdminNavBar.dart';
import 'package:wefaq/newReporteAccountsList.dart';
import 'package:wefaq/resolvedAcc.dart';
import 'package:wefaq/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Main Stateful Widget Start
class AdminAccountTabs extends StatefulWidget {
  @override
  _ListViewTabsState createState() => _ListViewTabsState();
}

class _ListViewTabsState extends State<AdminAccountTabs> {
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
            title: Text('Reported Accounts',
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
                    showDialogFunc(context);
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
                Tab(
                  text: 'New Accounts',
                ),
                Tab(text: 'Resolved Accounts'),
              ],
            ),
          ),
          body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            newReportedAccList(),
            resolvedAccount(),
          ]),
          bottomNavigationBar: AdminCustomNavigationBar(
            currentHomeScreen: 2,
            updatePage: () {},
          ),
        ));
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

showDialogFunc(context) {
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
