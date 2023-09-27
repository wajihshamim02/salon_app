import 'dart:convert';

import 'package:app_hair/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
// import 'package:salon_app/constants.dart';
// import 'package:salon_app/screen/available_time_slot.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'available_time_slot.dart';

class Salon_screen extends StatefulWidget {
  final dynamic service;
  const Salon_screen({Key? key, this.service}) : super(key: key);

  @override
  State<Salon_screen> createState() => _Salon_screenState();
}

class _Salon_screenState extends State<Salon_screen> {
  var users;
  var confirmedBooking;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;
  String? email, mobileNo, name;

  int selectedIndex = 0;
  List slots = [
    '9 am - 10 am',
    '10 am - 11 am',
    '11 am - 12 am',
    '12 pm - 1 pm',
    '1 pm - 2 pm',
    '2 pm - 3 pm',
    '3 pm - 4 pm',
    '4 pm - 5 pm',
    '5 pm - 6 pm',
    '6 pm - 7 pm',
    '7 pm - 8 pm',
    '8 pm - 9 pm',
  ];
  // Future<void> getslot() async {
  //   var res = await http.post(Uri.parse(url_timeslot),
  //       body: {'salonid': salon_id.toString()}); //do it
  //   var data = await jsonDecode(res.body);
  //   setState(() {
  //     TimeSlot = data;
  //   });

  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => Time_Slot()));
  // }

  Future<dynamic> botom_sheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 400.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Are you sure you want to confirm booking?',
                    style: GoogleFonts.ubuntu(
                      fontSize: 24.0,
                    )),
                Text('${widget.service['title']}',
                    style: GoogleFonts.ubuntu(
                      fontSize: 24.0,
                    )),
                Text('Price ${widget.service['price']}',
                    style: GoogleFonts.ubuntu(
                      fontSize: 24.0,
                    )),
                Text('Between ${slots[selectedIndex]}',
                    style: GoogleFonts.ubuntu(
                      fontSize: 24.0,
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          confirmBooking(
                              userId,
                              email!,
                              mobileNo!,
                              widget.service['title'],
                              widget.service['price'],
                              widget.service['description'],
                              slots[selectedIndex]);
                          fetchBooking();
                        },
                        child: Text('Confirm booking')),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: isLoading == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Fetching booked data...')],
                ),
              )
            : Column(
                children: [
                  Material(
                    elevation: 2.0,
                    child: Container(
                      width: double.infinity,
                      child: Image(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(widget.service['image'])),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0, left: 6.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  85.0, 8.0, 85.0, 0.0),
                              child: Divider(
                                color: Colors.black,
                                thickness: 5,
                              ),
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            Text(widget.service['title'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 12.0,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.service['description'].length,
                                itemBuilder: (context, index) {
                                  final item = widget.service['description'];
                                  return Column(
                                    children: [
                                      Text('${item[index]}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700)),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Text('Price: ${widget.service['price']}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18.0,
                                )),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    elevation: 5.0,
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Back',
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 17.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    elevation: 5.0,
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      bool isBooked = false;
                                      var timeSlot;
                                      for (var i = 0;
                                          i < confirmedBooking.length;
                                          i++) {
                                        if (confirmedBooking[i]['userId'] ==
                                                userId &&
                                            confirmedBooking[i]['title'] ==
                                                widget.service['title']) {
                                          isBooked = true;
                                          timeSlot =
                                              confirmedBooking[i]['timeSlot'];
                                        }
                                      }

                                      if (isBooked == true) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              title: Text(
                                                  'You cannot confirm booking again'),
                                              content: Text(
                                                  'You already set booking between ${timeSlot}'),
                                              actions: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ]),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => StatefulBuilder(
                                              builder: (context, setState) {
                                            return AlertDialog(
                                              title: Text('Select time slot'),
                                              actions: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  height: 400,
                                                  child: ListView.builder(
                                                    itemCount: slots.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex =
                                                                index;
                                                          });
                                                        },
                                                        child: Card(
                                                          color: selectedIndex ==
                                                                  index
                                                              ? Colors
                                                                  .grey.shade300
                                                              : Colors.white,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                                '${slots[index]}'),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          botom_sheet(context);
                                                        },
                                                        child: Text(
                                                            'Confirm slot')),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Book',
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 17.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void confirmBooking(String userId, String email, String mobileNo,
      String title, String price, List description, String timeSlot) {
    try {
      FirebaseFirestore.instance.collection('confirmBooking').add({
        'userId': userId,
        'name': name,
        'email': email,
        'contact': mobileNo,
        'title': title,
        'price': price,
        'description': description,
        'timeSlot': timeSlot
      });
      Future.delayed(
        Duration(seconds: 3),
        () {
          CircularProgressIndicator();
        },
      );
      utils.flushbarmessagegreen('You have confirmed your booking', context);
    } catch (e) {
      utils.flushbarmessagegreen(
          'Something went wrong booking didn\'t confirmed yet', context);
    }
  }

  void fetchUsers() async {
    users = await FirebaseFirestore.instance.collection('users').get();
    for (var i = 0; i < users.docs.length; i++) {
      if (users.docs[i]['userid'] == userId) {
        setState(() {
          name = users.docs[i]['name'];
          email = users.docs[i]['email'];
          mobileNo = users.docs[i]['mobilenumber'];
        });
      }
    }
    print(email);
    print(mobileNo);

    fetchBooking();
  }

  void fetchBooking() async {
    var fetchConfirmedBooking =
        await FirebaseFirestore.instance.collection('confirmBooking').get();
    setState(() {
      confirmedBooking = fetchConfirmedBooking.docs;
      isLoading = false;
    });
  }
}
