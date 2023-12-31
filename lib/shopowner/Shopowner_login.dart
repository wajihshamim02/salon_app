import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:app_hair/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:salon_app/shopowner/customerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../starting_screens/components/rounded_input.dart';
import 'customerpage.dart';
// import 'package:salon_app/constants.dart';

String _saloshopid = "";
String _salonshopemail = "";
String _salonshopnumber = "";

class Shop_owner_login extends StatefulWidget {
  Shop_owner_login({Key? key}) : super(key: key);

  @override
  State<Shop_owner_login> createState() => _Shop_owner_loginState();
}

class _Shop_owner_loginState extends State<Shop_owner_login> {
  Future<void> verifiy_owner() async {
    try {
      var res = await http.post(Uri.parse(url_ownerdetail), body: {
        'id': _saloshopid,
        'email': _salonshopemail,
        'number': _salonshopnumber
      });
      var data = await jsonDecode(res.body);
      if (data.toString() != 'Error') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('id', _saloshopid);
        prefs.setString('email_owner', _salonshopemail);
        prefs.setString('num', _salonshopnumber);
        setState(() {
          OwnerDetail = data;
        });
        var res_2 = await http.post(Uri.parse(url_todaysbooking),
            body: {'id': prefs.getString('id')});
        var data_2 = await jsonDecode(res_2.body);
        setState(() {
          TodayBooking = data_2;
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => customer()));
      }
    } catch (e) {
      print(e);
    }
  }
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 68, 171, 255),
        title: Text(
          'Verification',
          style: GoogleFonts.ubuntu(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80.0,
              ),
              Center(
                child: Text(
                  'ShopOwner Login',
                  style: GoogleFonts.ubuntu(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20, right: 20),
              //   child: TextField(
              //     onChanged: (value) {
              //       _saloshopid = value;
              //     },
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(
              //         prefixIcon: Icon(
              //           Icons.perm_identity,
              //           color: Color.fromARGB(255, 68, 171, 255),
              //         ),
              //         label: Text('Salon Id'),
              //         fillColor: Colors.white,
              //         filled: true,
              //         border: OutlineInputBorder(
              //             borderSide:
              //                 BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              //             borderRadius: BorderRadius.circular(10))),
              //   ),
              // ),
              // RoundedInput(
              //   inputtype: TextInputType.phone,
              //   hintText: 'Sale ID',
              //   borerColor: Colors.grey,
              //   labeltext: '',
              //   obsecuretext: false,
              //   prefixicon: Icons.insert_drive_file_outlined,
              //   controller: mobilenumcontroller,
              //   validator: (String? value) {
              //     String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
              //     RegExp regExp = RegExp(pattern);
              //     if (value?.length == 0) {
              //       return 'Please Enter Your mobile number';
              //     } else if (!regExp.hasMatch(value!)) {
              //       return 'Please enter valid mobile number';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(
                height: 10,
              ),
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 20, right: 20),
              //   child: TextField(
              //     onChanged: (value) {
              //       _salonshopemail = value;
              //     },
              //     keyboardType: TextInputType.emailAddress,
              //     decoration: InputDecoration(
              //         prefixIcon: Icon(
              //           Icons.mail_outline_outlined,
              //           color: Color.fromARGB(255, 68, 171, 255),
              //         ),
              //         label: Text('email'),
              //         fillColor: Colors.white,
              //         filled: true,
              //         border: OutlineInputBorder(
              //             borderSide:
              //                 BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              //             borderRadius: BorderRadius.circular(10))),
              //   ),
              // ),

              SizedBox(
                height: 10,
              ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 20, right: 20),
              //   child: TextField(
              //     onChanged: (value) {
              //       _salonshopnumber = value;
              //     },
              //     keyboardType: TextInputType.phone,
              //     decoration: InputDecoration(
              //         prefixIcon: Icon(
              //           Icons.phone,
              //           color: Color.fromARGB(255, 68, 171, 255),
              //         ),
              //         label: Text('Number'),
              //         fillColor: Colors.white,
              //         filled: true,
              //         border: OutlineInputBorder(
              //             borderSide:
              //                 BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              //             borderRadius: BorderRadius.circular(10))),
              //   ),
              // ),
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
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                  color: Color.fromARGB(255, 68, 171, 255),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      //  side: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(
                    10,
                  )),
                  onPressed: () {
                    if (emailEditingcontroller.text == 'admin@gmail.com' &&
                        passwordeditingcontroller.text == 'admin123') {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => customer()));
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        utils.flushbarmessagegreen(
                            'Login Successfully', context);
                      });
                    } else {
                      utils.flushbarmessagered('Invalid Credentials', context);
                    }

                    // if (_salonshopemail != null &&
                    //     _salonshopnumber != null &&
                    //     _saloshopid != null) {
                    //   verifiy_owner();
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(70, 8, 70, 8),
                    child: Text(
                      'LogIn',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  )),
              SizedBox(
                height: 40,
              ),
              // Text(
              //   'New to this app? Then Click',
              //   style: TextStyle(fontSize: 15),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // MaterialButton(
              //     color: Color.fromARGB(255, 114, 191, 255),
              //     elevation: 2,
              //     shape: RoundedRectangleBorder(
              //         //  side: BorderSide(color: Colors.black, width: 2),
              //         borderRadius: BorderRadius.circular(
              //       10,
              //     )),
              //     onPressed: () async {
              //       final String url =
              //           'https://docs.google.com/forms/d/e/1FAIpQLSceJY22o43npEg77uxGViJj3bDin_01ilUhxoA0fcNd9hAgDQ/viewform?usp=sf_link';

              //       await launchUrl(Uri.parse(url));
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(70, 8, 70, 8),
              //       child: Text(
              //         'New',
              //         style: TextStyle(fontSize: 25, color: Colors.white),
              //       ),
              //     )),
            ],
          ),
        ),
      ),
    ));
  }
}
