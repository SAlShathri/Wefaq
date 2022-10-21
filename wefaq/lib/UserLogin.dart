import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/HomePage.dart';

import 'package:wefaq/UserRegisteration.dart';
import 'package:wefaq/backgroundLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:cool_alert/cool_alert.dart';

import 'main.dart';

class UserLogin extends StatefulWidget {
  static const String screenRoute = 'UserLogin';

  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  bool showpass = true;
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;
  var names = [];
  var emails = [];

  @override
  void initState() {
   get();
    super.initState();
  }

  Future get() async {
    var fillterd = FirebaseFirestore.instance
        .collection("AllProjects")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();
    await for (var snapshot in fillterd)
      for (var project in snapshot.docs) {
        setState(() {
         names.add(project["name"]);
        
         
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Form(
          key: _FormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Log in ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(199, 66, 23, 139),
                      fontSize: 36),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "example@email.com",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 202, 198, 198)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(199, 66, 23, 139),
                      )),
                  validator: MultiValidator(
                      [RequiredValidator(errorText: 'required')]),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "required";
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: showpass,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "********",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 202, 198, 198)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontSize: 19,
                      color: Color.fromARGB(199, 66, 23, 139),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showpass = !showpass;
                        });
                      },
                      child: showpass
                          ? const Icon(
                              Icons.visibility_off,
                            )
                          : Icon(
                              Icons.visibility,
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    _FormKey.currentState?.validate();
                    final rec = await FirebaseFirestore.instance
                        .collection('users')
                        .where("Email", isEqualTo: email)
                        .where("status", isEqualTo: "inactive")
                        .get();
                        final del = await FirebaseFirestore.instance
                        .collection('users')
                        .where("Email", isEqualTo: email)
                        .where("status", isEqualTo: "deleted")
                        .get();
                    //if ( rec.docs.isEmpty)

                    if (rec.docs.isNotEmpty) {
                      showDialogFunc();
                    }
                    
                   else

                    if (del.docs.isNotEmpty) {
                       CoolAlert.show(
                            context: context,
                            title: "Sorry",
                            confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                            //cancelBtnColor: Color.fromARGB(144, 64, 6, 87),
                            type: CoolAlertType.error,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text: "Incorrect username or password",
                            confirmBtnText: 'Try again',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                    }

                    //loding indicator
                    /*showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: ((context) =>
                            Center(child: CircularProgressIndicator())));
        */
                    else {
                      if (_FormKey.currentState!.validate()) {
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                            print("Logged in Succesfully");
                          }
                        } catch (e) {
                          print(e);
                          /*   validator:
                      MultiValidator([
                        RequiredValidator(
                            errorText: 'Incorrect username or password')
                      ]);*/
                          CoolAlert.show(
                            context: context,
                            title: "Sorry",
                            confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                            //cancelBtnColor: Color.fromARGB(144, 64, 6, 87),
                            type: CoolAlertType.error,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text: "Incorrect username or password",
                            confirmBtnText: 'Try again',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      }
                    }
                    // hide the loding indicator
                    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(colors: [
                          Color.fromARGB(144, 67, 7, 87),
                          Color.fromARGB(221, 137, 171, 187)
                        ])),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70, vertical: 0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserRegistratin()))
                  },
                  child: Text(
                    "New User? Register",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(123, 11, 13, 18)),
                  ),
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
     for (var i =0 ;i<names.length;i++) {
        FirebaseFirestore.instance
            .collection('AllProjects')
            .doc(names[i].toString() + "-" + FirebaseAuth.instance.currentUser!.email!)
            .delete();
        FirebaseFirestore.instance
            .collection("AllJoinRequests")
            .doc(names[i].toString() + "-" +  FirebaseAuth.instance.currentUser!.email!)
            .delete();
      }

    FirebaseFirestore.instance
        .collection('users')
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
                    height: 210,
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
                                "your account is inactive, do you want to restore it or delete it immediately?",
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
                                FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .update({'status': 'active'});

                                  CoolAlert.show(
                                    context: context,
                                    title: "your account is active now",
                                    confirmBtnColor:
                                        Color.fromARGB(144, 64, 7, 87),
                                    onConfirmBtnTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserLogin()));
                                    },
                                    type: CoolAlertType.success,
                                    backgroundColor:
                                        Color.fromARGB(221, 212, 189, 227),
                                    text: "you can login",
                                  );
                                //  FirebaseFirestore.instance
                                //       .collection('users')
                                //       .doc(FirebaseAuth
                                //           .instance.currentUser!.email)
                                //       .update({'status': 'deleted'});
                                // deleteprofile();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => UserLogin()));
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
                                      Color.fromARGB(152, 24, 205, 33),
                                        Color.fromARGB(152, 24, 205, 33)
                                    ])),
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  "restore",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 40),
                              child: ElevatedButton(
                                onPressed: () {
                                   FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .update({'status': 'deleted'});
                                deleteprofile();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserLogin()));
                                  
                                  // deleteprofile();
                                  // Navigator.push(context,
                                  // MaterialPageRoute(builder: (context) => UserLogin()));
                                },
                                style: ElevatedButton.styleFrom(
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
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
                                    "delete",
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
