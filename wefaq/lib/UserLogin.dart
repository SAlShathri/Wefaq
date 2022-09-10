import 'package:flutter/material.dart';
import 'package:wefaq/UserRegisteration.dart';
import 'package:wefaq/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/postProject.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:wefaq/projectsScreen.dart';

import 'main.dart';

class UserLogin extends StatefulWidget {
  static const String screenRoute = 'UserLogin';

  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;

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
                  //   cursorColor: Color.fromARGB(255, 75, 3, 174),
                  decoration: InputDecoration(
                      //      enabledBorder: UnderlineInputBorder(
                      //        borderSide:
                      //           BorderSide(color: Color.fromARGB(255, 151, 134, 183)),
                      //     ),
                      //   focusedBorder: UnderlineInputBorder(
                      //      borderSide:
                      //         BorderSide(color: Color.fromARGB(255, 110, 19, 201)),
                      //    ),
                      //border: InputBorder.,
                      labelStyle: TextStyle(
                          //color: Color.fromARGB(255, 16, 16, 17),
                          ),
                      labelText: "Email"),
                  validator: MultiValidator(
                      [RequiredValidator(errorText: 'Email is required')]),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  //validator: MultiValidator(
                  //  [RequiredValidator(errorText: 'Email is required')]),
                ),
              ),

              //  Container(
              //   alignment: Alignment.centerRight,
              //margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //    child: Text(
              //       "Forgot your password?",
              //       style: TextStyle(
              //          fontSize: 12,
              //          color: Color(0XFF2661FA)
              //        ),
              //      ),
              //    ),

              SizedBox(height: size.height * 0.05),

              Container(
                //alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    _FormKey.currentState?.validate();
                    //loding indicator
                    /*showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: ((context) =>
                            Center(child: CircularProgressIndicator())));
        */
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectsListViewPage()));
                        print("Logged in Succesfully");
                      }
                    } catch (e) {
                      print(e);
                      validator:
                      MultiValidator([
                        RequiredValidator(
                            errorText: 'Incorrect username or password')
                      ]);
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
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(fontWeight: FontWeight.bold ),
                    ),
                  ),
                ),
              ),

              Container(
                //alignment: Alignment.centerRight,
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
}
