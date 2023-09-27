import 'dart:convert';

import 'package:app_hair/starting_screens/components/rounded_button.dart';
import 'package:app_hair/starting_screens/login/password_change.dart';
import 'package:app_hair/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../components/rounded_input.dart';

String email_fp = '';

class Forgetpassword extends StatefulWidget {
  Forgetpassword({Key? key}) : super(key: key);

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  Future<void> checkemail() async {
    var res = await http
        .post(Uri.parse(url_forgetpassword), body: {'email': email_fp});
    var data = await jsonDecode(res.body);

    if (data.toString() == 'Success') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PasswordChange()));
    } else {
      showAlertDialog(context);
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailEditingcontroller.dispose();
  }

  // firebase
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  final TextEditingController emailEditingcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // var email = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFc6ece6),
        title: Text(
          'Forget Password',
          style: GoogleFonts.ubuntu(
              fontSize: 23.0,
              fontWeight: FontWeight.bold,
              shadows: [
                const Shadow(
                    // bottomLeft
                    offset: Offset(-1.0, -1.0),
                    color: Color.fromARGB(255, 196, 196, 196)),
                const Shadow(
                    // bottomRight
                    offset: Offset(1.0, -1.0),
                    color: Color.fromARGB(255, 196, 196, 196)),
                const Shadow(
                    // topRight
                    offset: Offset(1.0, 1.0),
                    color: Color.fromARGB(255, 196, 196, 196)),
                const Shadow(
                    // topLeft
                    offset: Offset(-1.0, 1.0),
                    color: Color.fromARGB(255, 196, 196, 196)),
              ]),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Image.asset(
                'images/lock.png',
                height: 200,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Text(
                  'Enter your email here',
                  style: GoogleFonts.ubuntu(fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20, right: 20),
              //   child: Material(
              //     elevation: 1.0,
              //     child: TextField(
              //       onChanged: (value) {
              //         email_fp = value;
              //       },
              //       style: GoogleFonts.ubuntu(fontSize: 20),
              //       keyboardType: TextInputType.emailAddress,
              //       textAlign: TextAlign.center,
              //       decoration: InputDecoration(
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(5.0),
              //             borderSide: const BorderSide(
              //               width: 5,
              //             )),
              //         fillColor: Colors.white,
              //         filled: true,
              //         label: Text('email'),
              //       ),
              //     ),
              //   ),
              // ),
              Center(
                child: RoundedInput(
                  inputtype: TextInputType.emailAddress,
                  hintText: 'Email',
                  borerColor: Colors.grey,
                  labeltext: '',
                  obsecuretext: false,
                  prefixicon: Icons.mail,
                  controller: emailEditingcontroller,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Your Email");
                    }
                    // reg expression for email validation
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              RoundedButton(
                  title: 'Submit',
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        // email = emailEditingcontroller.text;
                        // resetPassword(emailEditingcontroller.text);
                        ForgotPassword1(emailEditingcontroller.text);
                        // emailEditingcontroller.clear();
                      });
                    }
                  })
              // MaterialButton(
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         side: const BorderSide(
              //             width: 2.5, color: Color.fromARGB(255, 57, 255, 225))),
              //     onPressed: () {
              //       if (email_fp != null) {
              //         checkemail();
              //       }
              //     },
              //     child: const Padding(
              //       padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              //       child: Text(
              //         'Submit',
              //         style: TextStyle(
              //             fontSize: 28.0,
              //             color: Color.fromARGB(255, 57, 255, 225)),
              //       ),
              //     ))
            ],
          ),
        ),
      ),
    );
  }

  void ForgotPassword1(String email) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.sendPasswordResetEmail(email: email).then((uid) => {
              utils.flushbarmessagegreen('Check Your Email', context),
              // //Navigate to bottom Nav bar
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => bottomnav())),
            });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case 'wrong-password':
            errorMessage = "Your password is wrong.";
            break;
          case 'user-not-found':
            errorMessage = "User with this email doesn't exist.";
            break;
          case 'user-disabled':
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        utils.flushbarmessagered(errorMessage!, context);
        print(error.code);
      }
    }
  }

  resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Password Reset Email has been sent !",
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No user found for that email");
        utils.flushbarmessagered('No user found for that email', context);
      }
    }
  }
}

showAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("No such email found"),
    content: Text("Try to Sign up first"),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
