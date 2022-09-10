// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:form_field_validator/form_field_validator.dart';

class UserRegistratin extends StatefulWidget {
  static const String screenRoute = 'UserRegistratin';

  const UserRegistratin({Key? key}) : super(key: key);

  @override
  _UserRegistratin createState() => _UserRegistratin();

  void onSubmit(String text) {}
}

class _UserRegistratin extends State<UserRegistratin> {
  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool showpass = true;
  bool has12char = false;
  bool hasuppercase = false;
  bool hasspecial = false;
  final ucasereg = RegExp('[A-Z]');
  final digit = RegExp('[1-9]');
  final _passcontroller = TextEditingController();
  final _confirmpasscontroller = TextEditingController();
//<<<<<<< HEAD
  // final controller = TextEditingController();

//String? get _errorText {
  // at any time, we can get the text from _controller.value.text
  //final text = controller.value.text;
  // Note: you can do your own custom validation here
  // Move this logic this outside the widget for more testable code
  // if (text.isEmpty) {
//    return 'Can\'t be empty';
  // }
  // if (text.length < 4) {
  //   return 'Too short';
  // }
  // return null if the text is valid
  // return null;
//}

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  late String FirstName;
  late String LastName;
  late String email;
  late String password;

  // void _submit() {
  // if there is no error text
  // if (_errorText == null) {
  // notify the parent widget via the onSubmit callback
  //   widget.onSubmit( controller.value.text);
  // }
//}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Form(
          //  autovalidateMode: AutovalidateMode.always,
          key: _FormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Register",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(199, 66, 23, 139),
                      fontSize: 36),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.00),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),

                child: TextFormField(
                  maxLength: 10,
                  onChanged: (value) {
                    FirstName = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)) {
                      return "Name must contain only English letters";
                    }
                  },
                  // },
                  //controller: controller,
                  decoration: InputDecoration(
                    labelText: "First name",
                    //errorText: _errorText ,
                  ),
                ),

                //  onChanged: (text) => setState(() => text),
              ),
              SizedBox(height: size.height * 0.00),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  maxLength: 10,
                  onChanged: (value) {
                    LastName = value;
                  },
                  decoration: InputDecoration(labelText: "Last name"),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)) {
                      return "Name must contain only English letters";
                    }
                  },
                ),
              ),
              SizedBox(height: size.height * 0.00),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: emailcontroller,
                  //  validator: (email) => email != null && !EmailValidator.validate(email!)? 'invalid email': null ,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "required"),
                    EmailValidator(errorText: "not valid email"),
                  ]),

                  onChanged: (value) {
                    final form = _FormKey.currentState!;
                    email = value;
                    form.validate();
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                ),
              ),
              SizedBox(height: size.height * 0.00),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: passcontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "required";
                    }
                  },
                  onChanged: (value) {
                    if (value.characters.length >= 8) {
                      setState(() {
                        has12char = true;
                      });
                    } else {
                      has12char = false;
                    }

                    ///  password = value;
                    if (value.contains(ucasereg)) {
                      setState(() {
                        hasuppercase = true;
                      });
                    } else {
                      hasuppercase = false;
                    }
                    if (value.contains(digit)) {
                      setState(() {
                        hasspecial = true;
                      });
                    } else {
                      hasspecial = false;
                    }
                  },
                  obscureText: showpass,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showpass = !showpass;
                        });
                      },
                      child: !showpass
                          ? const Icon(
                              Icons.visibility_off,
                            )
                          : Icon(
                              Icons.visibility,
                            ),
                    ),
                  ),

                  //obscureText: true,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                //  child: Divider(
                //  color: Color.fromARGB(255, 224, 30, 195)
                //),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    children: [
                      const Text('at least 8 characters'),
                      Spacer(),
                      has12char
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                    ],
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Divider(color: Color.fromARGB(255, 126, 123, 123)),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    children: [
                      const Text('1 numeric characters'),
                      Spacer(),
                      hasspecial
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                    ],
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Divider(color: Color.fromARGB(255, 126, 123, 123)),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    children: [
                      const Text('1 uppercase letter'),
                      Spacer(),
                      hasuppercase
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.error,
                              color: Colors.red,
                            )
                    ],
                  )),
              SizedBox(height: size.height * 0.01),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _confirmpasscontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "required";
                    }
                    if (value != passcontroller.value.text) {
                      return 'passwords do not match ! ';
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(labelText: "Confirm Password"),
                  obscureText: true,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                //alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    //print(FisrtName);
                    //print(LastName);
                    //print(email);
                    //print(password);

                    if (_FormKey.currentState!.validate()) {
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                        print("Account Created Successfully");

                        _firestore.collection('users').add({
                          'FirstName': FirstName,
                          'LastName': LastName,
                          'Email': email,
                          'password': password,
                        });

                        print("user is stored Successfully");

                        CoolAlert.show(
                          context: context,
                          title: "Success!",
                          confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                          type: CoolAlertType.success,
                          backgroundColor: Color.fromARGB(221, 212, 189, 227),
                          text: "Created account successfully",
                          confirmBtnText: 'Log in',
                          onConfirmBtnTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserLogin()));
                          },
                        );
                        //openDialog();
                      } catch (e) {
                        print(
                            "Error ${e.toString()}"); //printing the error massege----------edit this later
                      }

                      //controller.value.text.isNotEmpty
                      //? _submit
                      //: null ;
                    }
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
                    width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(colors: [
                          Color.fromARGB(144, 67, 7, 87),
                          Color.fromARGB(221, 137, 171, 187)
                        ])),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      //style: Theme.of(context).textTheme.bodyLarge,

                      //  style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                //alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserLogin()))
                  },
                  child: Text(
                    "Already Have an Account? Log in",
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
/*
  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('You have created an account successfully'),
          actions: [
            TextButton(
              child: Text('Log in'),
              onPressed: submit,
            ),
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserLogin()));
  }

*/
}
