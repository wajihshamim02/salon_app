import 'package:app_hair/starting_screens/Login_page.dart';
import 'package:app_hair/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../components/rounded_button.dart';
import '../components/rounded_input.dart';
import '../components/rounded_password_input.dart';
import '../emailverify.dart';

var email_register;
var password_register;
var name_register;
var number_register;

class RegisterForm extends StatefulWidget {
  RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // final _formKey = GlobalKey<FormState>();

  static TextEditingController mobilenumcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController emailEditingcontroller = TextEditingController();
  final TextEditingController passwordeditingcontroller =
      TextEditingController();
  String? errorMessage;

  // firebase
  final _auth = FirebaseAuth.instance;
//
  @override
  void dispose() {
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    emailEditingcontroller.dispose();
    mobilenumcontroller.dispose();
    passwordeditingcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: widget.size.width,
            height: widget.defaultLoginSize,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Welcome',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: 40),
                    // SizedBox(height: 40),
                    RoundedInput(
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
                    RoundedInput(
                      inputtype: TextInputType.phone,
                      hintText: 'Mobile Number',
                      borerColor: Colors.grey,
                      labeltext: '',
                      obsecuretext: false,
                      prefixicon: Icons.mobile_friendly,
                      controller: mobilenumcontroller,
                      validator: (String? value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = RegExp(pattern);
                        if (value?.length == 0) {
                          return 'Please Enter Your mobile number';
                        } else if (!regExp.hasMatch(value!)) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                    ),

                    RoundedInput(
                      hintText: 'Name',
                      borerColor: Colors.grey,
                      labeltext: '',
                      obsecuretext: false,
                      prefixicon: Icons.person,
                      inputtype: TextInputType.name,
                      controller: firstnamecontroller,
                      validator: (String? value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Valid name(Min. 3 Character)");
                        }
                        return null;
                      },
                    ),

                    RoundedInput(
                      inputtype: TextInputType.visiblePassword,
                      suffixicon: Icons.visibility,
                      suffixIcon2: Icons.visibility_off,
                      hintText: 'Password',
                      borerColor: Colors.grey,
                      labeltext: '',
                      obsecuretext: true,
                      prefixicon: Icons.lock,
                      controller: passwordeditingcontroller,
                      validator: (String? value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    RoundedButton(
                        title: 'SIGN UP',
                        ontap: () {
                          setState(() {
                            signUp(emailEditingcontroller.text,
                                passwordeditingcontroller.text);
                          });

                          // if (email_register != null &&
                          //     number_register != null &&
                          //     name_register != null &&
                          //     password_register != null) {
                          //   sendOtp(context);

                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => Verification()));
                        }), //ass register

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          // Fluttertoast.showToast(msg: e!.message);
          utils.flushbarmessagered(e!.message, context);
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

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    // UserModel userModel = UserModel();

    // // writing all the values
    // userModel.email = user!.email;
    // userModel.uid = user.uid;
    // userModel.firstName = firstnamecontroller.text;
    // userModel.secondName = lastnamecontroller.text;
    // userModel.mobilenumber = mobilenumcontroller.text;
    Map<String, dynamic> userData = {
      'userid': FirebaseAuth.instance.currentUser!.uid,
      'name': firstnamecontroller.text,
      // 'Lastname': lastnamecontroller.text,
      'mobilenumber': mobilenumcontroller.text,
      'email': emailEditingcontroller.text,
      // 'dropdownvalue': _selectedfield
    };
    await firebaseFirestore.collection("users").doc(user!.uid).set(userData);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      utils.flushbarmessagegreen('Account created successfully', context);
    });

    Navigator.push(
        (context), MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
