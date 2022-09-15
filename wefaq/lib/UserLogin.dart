import 'package:flutter/material.dart';
import 'package:wefaq/HomePage.dart';
import 'package:wefaq/UserRegisteration.dart';
import 'package:wefaq/backgroundLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wefaq/postProject.dart';
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
                    //loding indicator
                    /*showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: ((context) =>
                            Center(child: CircularProgressIndicator())));
        */
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
                          title: "Failed",
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
}
