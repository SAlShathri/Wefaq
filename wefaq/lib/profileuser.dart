import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/background.dart';
import 'package:wefaq/editProfile.dart';
import 'package:wefaq/userProjects.dart';
import 'bottom_bar_custom.dart';
import 'package:wefaq/myProjects.dart';

class viewprofile extends StatefulWidget {
  String userEmail;
  viewprofile({required this.userEmail});

  @override
  State<viewprofile> createState() => _viewprofileState(this.userEmail);
}

class _viewprofileState extends State<viewprofile> {
  String userEmail;
  _viewprofileState(this.userEmail);
  final auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  String fname = "";
  String lname = "";
  String about = "";
  String experince = "";
  String cerifi = "";
  String skills = "";
  String role = "";
  String gitHub = "";
  List<String> selectedOptionList = [];

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    var fillterd = _firestore
        .collection('users')
        .where("Email", isEqualTo: userEmail)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var user in snapshot.docs) {
        setState(() {
          fname = user["FirstName"].toString();
          lname = user["LastName"].toString();
          about = user["about"].toString();
          experince = user["experince"].toString();
          cerifi = user["cerifi"].toString();
          role = user["role"].toString();
          gitHub = user["gitHub"].toString();
          for (var skill in user["skills"])
            selectedOptionList.add(skill.toString());
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 238, 237, 240),
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(color: Colors.white)),
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
          backgroundColor: Color.fromARGB(255, 162, 148, 183),
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentHomeScreen: 0,
          updatePage: () {},
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Image(
                  image: AssetImage(
                    "assets/images/header.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 200, 15, 15),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 95),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Expanded(
                                          child: Column(children: <Widget>[
                                        Text("$fname" + " $lname",
                                            style: TextStyle(fontSize: 18)),
                                      ])),
                                      Expanded(
                                          child: Column(children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color.fromARGB(
                                                255, 141, 136, 146),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      editprofile()),
                                            );
                                          },
                                        ),
                                      ]))
                                    ]),
                                    Row(children: <Widget>[
                                      Expanded(
                                          child: Column(children: <Widget>[
                                        ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text("$role"),
                                          //You can add Subtitle here
                                        ),
                                      ])),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          userProjects(
                                                              userEmail:
                                                                  userEmail)),
                                                );
                                              },
                                              child: Text("My Projects"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.only(left: 15, top: 10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.15),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/layanP.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text("General Information"),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("About"),
                            subtitle: Text("$about"),
                            leading: Icon(Icons.format_align_center),
                          ),
                          ListTile(
                            title: Text("GitHub"),
                            subtitle: Text("$gitHub"),
                            leading: Icon(
                              LineIcons.github,
                              size: 35,
                              color: Color.fromARGB(255, 93, 18, 107),
                            ),
                          ),
                          ListTile(
                            title: Text("Experience"),
                            subtitle: Text("$experince"),
                            leading: Icon(Icons.calendar_view_day),
                          ),
                          ListTile(
                            title: Text("Skills"),
                            subtitle: Text(selectedOptionList.join(",")),
                            leading: Icon(Icons.schema_rounded),
                          ),
                          ListTile(
                            title: Text("Licenses & certifications"),
                            subtitle: Text("$cerifi"),
                            leading: Icon(
                              Icons.workspace_premium,
                              size: 33,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                      width: 80,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color.fromARGB(255, 89, 13, 161),
                                    Color.fromARGB(255, 101, 42, 155),
                                    Color.fromARGB(255, 117, 85, 148),
                                  ],
                                ),
                              ),
                            ),
                          ),
                         Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialogFunc();
                      // deleteprofile();
                      //   Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => UserLogin()));
                    },
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                       height: 50.0,
                            width: 150,
                     // width: size.width * 0.5,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: new LinearGradient(colors: [
                            Color.fromARGB(144, 67, 7, 87),
                            Color.fromARGB(221, 137, 171, 187)
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Delete Account",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> deleteprofile() async {
    print(FirebaseAuth.instance.currentUser!.email);
    //FirebaseFirestore.instance
      //                              .collection('AllPrpjects')
      //                              .doc(FirebaseAuth.instance.currentUser!.email)
      //                              .delete();

    FirebaseFirestore.instance.collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.email)
                                    .delete();
                                    
     await FirebaseAuth.instance.currentUser!.delete();
      
  }

  showDialogFunc() {
  return showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: const EdgeInsets.all(15),
                  height: 190,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Code for acceptance role
                      Row(children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Text(
                              "Are you sure you want to delete    your account ?",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(159, 64, 7, 87),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              // go to participant's profile
                            },
                          ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                      ]),
                      SizedBox(
                        height: 35,
                      ),
                      //----------------------------------------------------------------------------
                      Row(
                        children: <Widget>[
                          Text(""),
                          Text("        "),
                          ElevatedButton(
                            onPressed: () async {
                      
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => viewprofile(userEmail: 'Email',)  ));
                    },
                            style: ElevatedButton.styleFrom(
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40.0,
                              width: 100,
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(9.0),
                                  gradient: new LinearGradient(colors: [
                                    Color.fromARGB(144, 176, 175, 175),
                                    Color.fromARGB(144, 176, 175, 175),
                                  ])),
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            child: ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                            .collection('users')
                            .doc(
                                FirebaseAuth.instance.currentUser!.email)
                            .update({'status': 'inactive'});



                                CoolAlert.show(
                          context: context,
                          title: "your account is inactive now",
                          
                          confirmBtnColor: Color.fromARGB(144, 64, 7, 87),
                          onConfirmBtnTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserLogin() ));
                          },
                          type: CoolAlertType.success,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          
                          text: "you can reactivate your account within 1 week when you login",
                        );
                               // deleteprofile();
                                // Navigator.push(context,
                                // MaterialPageRoute(builder: (context) => UserLogin()));

                    
     
     
                                  
                              },
                              style: ElevatedButton.styleFrom(
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: const EdgeInsets.all(0),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                width: 100,
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    gradient: new LinearGradient(colors: [
                                      Color.fromARGB(144, 210, 2, 2),
                                      Color.fromARGB(144, 210, 2, 2)
                                    ])),
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )));
      });
}
}
