// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wefaq/background.dart';
import 'package:velocity_x/velocity_x.dart';

import 'bottom_bar_custom.dart';

class profileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 4,
        updatePage: () {},
      ),
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.2),
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/Fem.jpg'),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Nada",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(199, 66, 23, 139),
                      fontSize: 20),
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: size.height * 0.001),
            Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Nada@gmail.com",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(198, 98, 93, 107),
                      fontSize: 16),
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: size.height * 0.001),
            Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(197, 74, 28, 158),
                      fontSize: 16),
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: size.height * 0.02),
            profileMenuItem(
                text: 'Edit Profile',
                icon: Icons.edit_outlined,
                arrowShown: true),
            SizedBox(height: size.height * 0.01),
            profileMenuItem(
                text: 'Join Requests',
                icon: Icons.group_add_outlined,
                arrowShown: true),
            SizedBox(height: size.height * 0.01),
            profileMenuItem(
                text: 'Log out', icon: Icons.logout, arrowShown: false),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}

class profileMenuItem extends StatelessWidget {
  const profileMenuItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.arrowShown,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final bool arrowShown;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)),
            textStyle: TextStyle(color: Colors.white),
            padding: const EdgeInsets.all(0),
          ),
          child: Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  gradient: new LinearGradient(colors: [
                    Color.fromARGB(144, 64, 7, 87),
                    Color.fromARGB(221, 137, 171, 187)
                  ])), // BoxDecoration
              height: 50,
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Icon(
                          icon,
                          size: 35,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ), // Icon
                      ), // Padding
                      SizedBox(width: 10),
                      Text(
                        "$text",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(197, 255, 255, 255),
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ), // Text
                    ],
                  ),
                  arrowShown
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 40,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ), // Icon
                        )
                      : Container(), // Padding
                ],
              )),
        ));
  }
}
