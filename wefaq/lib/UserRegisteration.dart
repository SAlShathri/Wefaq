// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/UserLogin.dart';
import 'package:wefaq/backgroundLogin.dart';
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
  late String FirstName;
  late String LastName;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool showpass = true;
  bool showpass1 = true;
  bool has8char = false;
  bool hasuppercase = false;
  bool hasdigit = false;
  final ucasereg = RegExp('[A-Z]');
  final ara = RegExp(r'^[a-zA-Z]+$');
  final eng = RegExp(r'^[أ-ي]+$');
  final digit = RegExp('[1-9]');
  final _passcontroller = TextEditingController();
  final _confirmpasscontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(8.0),
        child: Background(
          //resizeToAvoidBottomInset: false,
          child: Form(
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _FormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 35),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 15,
                    onChanged: (value) {
                      FirstName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "required";
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!) &&
                          !RegExp(r'^[أ-ي]+$').hasMatch(value!)) {
                        return "Only English or Arabic letters";
                      }
                      //if( !(value.contains(eng)) &&  !(value.contains(ara)) ) {
                      //   return "Only English or Arabic letters";
                      //  }
                      //   },
                      //  !(value.contains(ucasereg))
                    },
                    //controller: controller,
                    decoration: InputDecoration(
                        hintText: "John",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 202, 198, 198)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: RichText(
                          text: TextSpan(
                              text: 'First Name',
                              style: const TextStyle(
                                  fontSize: 19,
                                  color: Color.fromARGB(199, 66, 23, 139)),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ))
                              ]),
                        )),
                  ),
                ),
                SizedBox(height: size.height * 0.00),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 15,
                    onChanged: (value) {
                      LastName = value;
                    },
                    decoration: InputDecoration(
                        hintText: "Doe",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 202, 198, 198)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: RichText(
                          text: TextSpan(
                              text: 'Last Name',
                              style: const TextStyle(
                                  fontSize: 19,
                                  color: Color.fromARGB(199, 66, 23, 139)),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ))
                              ]),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "required";
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!) &&
                          !RegExp(r'^[أ-ي]+$').hasMatch(value!)) {
                        return "Only English or Arabic letters";
                      }
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.0),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailcontroller,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "required"),
                      EmailValidator(errorText: "not valid email"),
                    ]),
                    onChanged: (value) {
                      email = value;
                      //form.validate();
                    },
                    decoration: InputDecoration(
                        hintText: "example@email.com",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 202, 198, 198)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: RichText(
                          text: TextSpan(
                              text: 'Email',
                              style: const TextStyle(
                                  fontSize: 19,
                                  color: Color.fromARGB(199, 66, 23, 139)),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ))
                              ]),
                        )),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: [AutofillHints.email],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "required";
                      }
                      if (!(value.characters.length >= 8) ||
                          !(value.contains(ucasereg)) ||
                          !(value.contains(digit))) {
                        return "";
                      }
                    },
                    onChanged: (value) {
                      if (value.characters.length >= 8) {
                        setState(() {
                          has8char = true;
                        });
                      } else {
                        has8char = false;
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
                          hasdigit = true;
                        });
                      } else {
                        hasdigit = false;
                      }

                      password = value;
                    },
                    obscureText: showpass,
                    decoration: InputDecoration(
                      hintText: "********",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 202, 198, 198)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      label: RichText(
                        text: TextSpan(
                            text: 'Password',
                            style: const TextStyle(
                                fontSize: 19,
                                color: Color.fromARGB(199, 66, 23, 139)),
                            children: [
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ))
                            ]),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            showpass = !showpass;
                          });
                        },
                        child: !showpass
                            ? const Icon(
                                Icons.visibility,
                              )
                            : Icon(
                                Icons.visibility_off,
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
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Row(
                      children: [
                        const Text('at least 8 characters'),
                        Spacer(),
                        has8char
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
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Divider(color: Color.fromARGB(255, 126, 123, 123)),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Row(
                      children: [
                        const Text('1 numeric character'),
                        Spacer(),
                        hasdigit
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
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Divider(color: Color.fromARGB(255, 126, 123, 123)),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
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
                SizedBox(height: size.height * 0.02),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    obscureText: showpass1,
                    decoration: InputDecoration(
                      hintText: "********",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 202, 198, 198)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      label: RichText(
                        text: TextSpan(
                            text: 'Confirm Password',
                            style: const TextStyle(
                                fontSize: 19,
                                color: Color.fromARGB(199, 66, 23, 139)),
                            children: [
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ))
                            ]),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            showpass1 = !showpass1;
                          });
                        },
                        child: !showpass1
                            ? const Icon(
                                Icons.visibility,
                              )
                            : Icon(
                                Icons.visibility_off,
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
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
                        } catch (e) {
                          print("Error ${e.toString()}");
                          CoolAlert.show(
                            context: context,
                            title: "Sorry",
                            confirmBtnColor: Color.fromARGB(144, 64, 6, 87),
                            type: CoolAlertType.error,
                            backgroundColor: Color.fromARGB(221, 212, 189, 227),
                            text:
                                "This Email address is already used by another account!",
                            confirmBtnText: 'Try again',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
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
                      ),
                    ),
                  ),
                ),
                Container(
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
      ),
    );
  }
}
