import 'dart:async';
import 'dart:convert';

import 'package:app_hair/starting_screens/SpalshScreen.dart';
import 'package:app_hair/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:salon_app/constants.dart';
// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../screen/profile_screen.dart';

class customer extends StatefulWidget {
  const customer({Key? key}) : super(key: key);

  @override
  State<customer> createState() => _customerState();
}

class _customerState extends State<customer> {
  var confirmedBooking;
  bool isLoading = true;
  // bool gettime(String time) {
  //   String changetimeformate = time[time.length - 2] + time[time.length - 1];
  //   int hr, min, sec;

  //   if (changetimeformate == 'PM' &&
  //       int.parse(time[0]) * 10 + int.parse(time[1]) != 12) {
  //     hr = 12 + int.parse(time[1]);
  //   } else {
  //     hr = int.parse(time[0]) * 10 + int.parse(time[1]);
  //   }
  //   min = int.parse(time[3]) * 10 + int.parse(time[4]);
  //   sec = int.parse(time[6]) * 10 + int.parse(time[7]);

  //   if (hr < int.parse(tdata[0]) * 10 + int.parse(tdata[1]) &&
  //       int.parse(tdata[0]) * 10 + int.parse(tdata[1]) <= 17 &&
  //       int.parse(tdata[0]) * 10 + int.parse(tdata[1]) >= 7) {
  //     return false;
  //   } else if (hr == int.parse(tdata[0]) * 10 + int.parse(tdata[1]) &&
  //       int.parse(tdata[0]) * 10 + int.parse(tdata[1]) <= 17 &&
  //       int.parse(tdata[0]) * 10 + int.parse(tdata[1]) >= 7) {
  //     if (min < int.parse(tdata[3]) * 10 + int.parse(tdata[4])) {
  //       return false;
  //     } else if (min == int.parse(tdata[3]) * 10 + int.parse(tdata[4])) {
  //       if (sec <= int.parse(tdata[6]) * 10 + int.parse(tdata[7])) {
  //         return false;
  //       }
  //     }
  //   }

  //   return true;
  // }

  // Future<void> UpdateScreen() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     var res_2 = await http.post(Uri.parse(url_todaysbooking),
  //         body: {'id': prefs.getString('id')});
  //     var data_2 = await jsonDecode(res_2.body);
  //     setState(() {
  //       TodayBooking = data_2;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Timer? timer;

  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(Duration(minutes: 10), (Timer t) => UpdateScreen());
    fetchBooking();
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 199, 230, 255),
        body: isLoading == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Fetching booked data...')],
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    actions: [
                      IconButton(
                          onPressed: () async {
                            // await FirebaseAuth.instance.signOut().then((value) {s
                            //   utils.flushbarmessagegreen('Sign out', context);
                            // });
                            showDialog(
                              context: context,
                              builder: ((BuildContext context) {
                                return AlertDialog(
                                  title: Text('Log out'),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        void Function(void Function())
                                            setState) {
                                      return Text(
                                          "Are you sure you want to log out");
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Okay',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 15),
                                      ),
                                      onPressed: () async {
                                        await FirebaseAuth.instance
                                            .signOut()
                                            .then((value) {
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            utils.flushbarmessagegreen(
                                                'Application is sign out',
                                                context);
                                          });
                                          Navigator.push(
                                              (context),
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Splash_Screen_Screen()));
                                        });

                                        // Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                          icon: Icon(Icons.logout_sharp))
                    ],
                    snap: false,
                    pinned: true,
                    floating: false,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text('Salon App',
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                            ) //TextStyle
                            ), //Text
                        background: Image(
                          height: 100,
                          width: 100,
                          image: AssetImage('images/logo2.png'),
                          fit: BoxFit.cover,
                        ) //Images.network
                        ), //FlexibleSpaceBar
                    expandedHeight: 230,
                    backgroundColor: Colors.blue,
                    //IconButton
                    //<Widget>[]
                  ), //SliverAppBar
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = confirmedBooking[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 12, 12, 0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color.fromARGB(255, 68, 171, 255),
                                    Color.fromARGB(255, 46, 161, 255),
                                  ]),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${item['timeSlot']}',
                                      style: GoogleFonts.ubuntu(fontSize: 22),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Booking_card_row(
                                      card_icon: Icons.face,
                                      card_text: '${item['name']}',
                                    ),
                                    Booking_card_row(
                                      card_icon: Icons.accessibility_new_sharp,
                                      card_text: '${item['title']}',
                                    ),
                                    Booking_card_row(
                                      card_icon: Icons.phone,
                                      card_text: '${item['contact']}',
                                    ),
                                    const SizedBox(height: 8),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      onPressed: () async {
                                        final Uri launchUri = Uri(
                                          scheme: 'tel',
                                          path: "+91" + '3162788562',
                                        );
                                        await launch(launchUri.toString());
                                      },
                                      color: const Color.fromARGB(
                                          255, 60, 190, 255),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(90, 2, 90, 2),
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        // } else {
                        //   return Padding(
                        //     padding: const EdgeInsets.fromLTRB(10, 12, 12, 0),
                        //     child: Material(
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(20)),
                        //       elevation: 3,
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //             gradient: const LinearGradient(colors: [
                        //               Color.fromARGB(255, 195, 206, 215),
                        //               Color.fromARGB(255, 162, 168, 173),
                        //             ]),
                        //             borderRadius: BorderRadius.circular(20.0)),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(12.0),
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 TodayBooking[index]['time_slot_start'] +
                        //                     ' - ' +
                        //                     TodayBooking[index]['time_slot_end'],
                        //                 style: GoogleFonts.ubuntu(fontSize: 22),
                        //               ),
                        //               const SizedBox(
                        //                 height: 4,
                        //               ),
                        //               Booking_card_row(
                        //                 card_icon: Icons.face,
                        //                 card_text: TodayBooking[index]['name'],
                        //               ),
                        //               Booking_card_row(
                        //                 card_icon: Icons.accessibility_new_sharp,
                        //                 card_text: TodayBooking[index]['type'],
                        //               ),
                        //               Booking_card_row(
                        //                 card_icon: Icons.phone,
                        //                 card_text: TodayBooking[index]['number'],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // }
                      } //ListTile
                      ,
                      childCount: confirmedBooking.length,
                    ), //SliverChildBuildDelegate
                  ) //SliverList
                ], //<Widget>[]
              ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 93, 172, 250),
            onPressed: () {
              // UpdateScreen();
              fetchBooking();
            },
            label: Text(
              'Refresh',
              style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.refresh)), //CustonScrollView
      ),
    );
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

class Booking_card_row extends StatelessWidget {
  final String card_text;
  final IconData card_icon;

  Booking_card_row({required this.card_icon, required this.card_text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          card_icon,
          color: const Color.fromARGB(255, 207, 233, 255),
          size: 30,
        ),
        const SizedBox(
          width: 12,
        ),
        Flexible(
          child: Text(
            card_text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
