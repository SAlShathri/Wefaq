import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/myProjects.dart';
import 'package:wefaq/screens/detail_screens/event_detail_screen.dart';
import 'HomePage.dart';
import 'bottom_bar_custom.dart';
import 'eventsScreen.dart';

class reportEvent extends StatefulWidget {
  String eventName;
  String eventOwner ;
  reportEvent({required this.eventName , required this.eventOwner});

  @override
  State<reportEvent> createState() => _reportEventState(eventName , eventOwner);
}

class _reportEventState extends State<reportEvent> {
  final _firestore = FirebaseFirestore.instance;
  
  final TextEditingController _noteEditingController =
      TextEditingController();
 
  
  // Project category list
  List<String> options = [];

  String? selectedreason;
  final auth = FirebaseAuth.instance;
  late User signedInUser;

  var name = '${FirebaseAuth.instance.currentUser!.displayName}'.split(' ');
  get fname => name.first;
  get lname => name.last;
  var Email = FirebaseAuth.instance.currentUser!.email;

  void initState() {
    // call the methods to fetch the data from the DB
    getreasonList();

    super.initState();
   
  }
  String eventName;
  String eventOwner ;
  _reportEventState(this.eventName , this.eventOwner);

  @override
  void dispose() {
    super.dispose();
  }

  

  void getreasonList() async {
    final categories = await _firestore.collection('reportreasons').get();
    for (var category in categories.docs) {
      for (var element in category['reportreasons']) {
        setState(() {
          options.add(element);
        });
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  automaticallyImplyLeading: false,
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
          backgroundColor: Color.fromARGB(255, 145, 124, 178),
          title: Text('Report event',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ))),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 2,
        updatePage: () {},
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
            children: <Widget>[
             Container(
                margin: EdgeInsets.only(left: 5, top: 1),
                alignment: Alignment.topLeft,
                child: Text("Why are you reporting $eventName event? ",
                    style: TextStyle(
                   //     fontWeight: FontWeight.w600,
                        color: Color.fromARGB(144, 64, 7, 87),
                        fontSize: 19),
                    textAlign: TextAlign.left),
              ),
              SizedBox(height: 25.0),
             
              
              DropdownButtonFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                hint: RichText(
                  text: TextSpan(
                      text: 'Report reason  ',
                      
                      style: const TextStyle(
                          fontSize: 18, color: Color.fromARGB(144, 64, 7, 87)),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                            ))
                      ]),
                ),
                items: options
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedreason = value as String?;
                  });
                },
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Color.fromARGB(221, 137, 171, 187),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(144, 64, 7, 87),
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value == "") {
                    return 'required';
                  }
                },
              ),
              SizedBox(height: 25.0),
            //  SizedBox(height: 4.0),
            
           //  SizedBox(height: 33.0),
              Scrollbar(
                thumbVisibility: true,
                child: TextFormField(
                //  autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 1000,
                    maxLines: 12,
                    decoration: InputDecoration(
                       floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Add a comment to your report (optional)',
                      hintStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 202, 198, 198)),
                      label: RichText(
                        text: TextSpan(
                            text: 'note',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(144, 64, 7, 87)),
                            children: [
                              // TextSpan(
                              //     text: ' *',
                              //     style: TextStyle(
                              //       color: Colors.red,
                              //     ))
                            ]),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(144, 64, 7, 87),
                          width: 2.0,
                        ),
                      ),
                    ),
                    controller: _noteEditingController,
                    validator: (value) {
                      if (!RegExp(r'^[a-z A-Z . ,]+$').hasMatch(value!) &&
                          !RegExp(r'^[, . أ-ي]+$').hasMatch(value!) && value.isNotEmpty) {
                        return "Only English or Arabic letters";
                      }
                      // if (value == null ||
                      //     value.isEmpty ||
                      //     value.trim() == '') {
                      //   return 'required';
                      // }

                      return null;
                    }),
              ),
              SizedBox(height: 15),
             
            
              SizedBox(
                width: 50,
                height: 50.0,
                child: ElevatedButton(
                  
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(144, 238, 22, 22),
                     shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0),
                      
                    ),
                    child: Container (
                //      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                       alignment: Alignment.center,
                      height: 50.0,
                      //width: 33,
                      padding: const EdgeInsets.all(0),
                    child: Text('Report',
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        // for sorting purpose
                        var now = new DateTime.now();
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        String? token =
                            await FirebaseMessaging.instance.getToken();
                        _firestore
                            .collection('reportedevents')
                            .doc(eventName + '-' +
                                Email.toString())
                            .set({
                          
                          
                          'reason': selectedreason,
                          'note': _noteEditingController.text,                                                                           
                          'user who reported': Email.toString(),
                          'token': token,
                          'created': now,
                          'cdate': formatter.format(now),
                          'reported event name' : eventName ,
                          "event owner": eventOwner,
                        });
                                              
                        _noteEditingController.clear();
                        
                        selectedreason = "";

                        //sucess message
                        CoolAlert.show(
                          context: context,
                          title: "Thanks for letting us know!",
                          
                          confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
                          onConfirmBtnTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen() ));
                          },
                          type: CoolAlertType.success,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          
                          text: "We'll review your report and take action if there is a voilation of our guidelines",
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}