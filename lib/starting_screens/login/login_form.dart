import 'dart:convert';

import 'package:app_hair/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Home_page/HomePage.dart';
import '../../constants.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input.dart';
import '../components/rounded_password_input.dart';
import 'forgetPassword.dart';

var email_login;
var password_login;
var name_login = '123';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    this.isLogin,
    this.animationDuration,
    this.size,
    this.defaultLoginSize,
  }) : super(key: key);

  final bool? isLogin;
  final Duration? animationDuration;
  final Size? size;
  final double? defaultLoginSize;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool loading = false;
  final TextEditingController phonecontroller = TextEditingController();
  bool _btnEnabled = false;

  bool onclick = false;
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  // final uid = FirebaseAuth.instance.currentUser!.uid;

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  void dispose() {
    super.dispose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin! ? 1.0 : 0.0,
      duration: widget.animationDuration! * 4,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: widget.size!.width,
          height: widget.defaultLoginSize,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 79,
                  ),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 35,
                    ),
                  ),
                  SizedBox(height: 40),
                  RoundedInput(
                    inputtype: TextInputType.emailAddress,
                    hintText: 'Email',
                    borerColor: Colors.grey,
                    labeltext: '',
                    obsecuretext: false,
                    prefixicon: Icons.mobile_friendly,
                    controller: emailEditingController,
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
                  RoundedInput(
                    suffixicon: Icons.visibility,
                    suffixIcon2: Icons.visibility_off,
                    inputtype: TextInputType.visiblePassword,
                    hintText: 'Password',
                    borerColor: Colors.grey,
                    labeltext: '',
                    obsecuretext: true,
                    prefixicon: Icons.lock,
                    controller: passwordEditingController,
                    validator: (String? value) {
                      RegExp regex = new RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return ("Password is required for login");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Password(Min. 6 Character)");
                      }
                      if (value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Forgetpassword()));
                      },
                      child: const Text(
                        'Forget Password ?',
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                      )),
                  SizedBox(height: 10),
                  RoundedButton(
                    title: 'LOGIN',
                    ontap: () {
                      setState(() {
                        signIn(emailEditingController.text,
                            passwordEditingController.text);
                      });
                      // if (email_login != null && password_login != null) {
                      //   Login(email_login, password_login, context);
                      // }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  Future signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    utils.flushbarmessagegreen('Login Successfully', context);
                  }),
                  // Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Home_Page_Screen())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
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
        // Fluttertoast.showToast(msg: errorMessage!);
        utils.flushbarmessagered(errorMessage!, context);
        print(error.code);
      }
    }
  }
}

Future<void> Login(
    String emailtxt, String password, BuildContext context) async {
  var response = await http.post(Uri.parse(url_login),
      body: {'email': emailtxt, 'password': password});
  var login_data = await jsonDecode(response.body);
  if (emailtxt != Null && password != Null) {
    final prefs = await SharedPreferences.getInstance();

    //   Navigator.push(
    //     //todo
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => const Home_Page_Screen()),
    //   );

    if (login_data.toString() == "Success") {
      prefs.setString('customer', name_login);
      customer_name = prefs.getString('customer');
      prefs.setString('Login', emailtxt);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home_Page_Screen()),
      );
    } else {
      print('not exist enter');
      _onAlertButtonPressed1(context);
    }
  }
}

_onAlertButtonPressed1(context) {
  AlertDialog alert = AlertDialog(
    title: Text('Account Not Exists'),
    content: Text("Please Sign up first"),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
