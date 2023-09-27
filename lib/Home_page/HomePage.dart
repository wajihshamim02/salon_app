import 'dart:convert';
import 'dart:io';
// import 'package:salon_app/Home_page/search_location.dart';
import 'package:app_hair/Home_page/search_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:salon_app/constants.dart';
// import 'package:salon_app/screen/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../screen/bookscreen.dart';
import '../screen/profile_screen.dart';
// import 'package:salon_app/Home_page/locations.dart';

class Home_Page_Screen extends StatefulWidget {
  const Home_Page_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Page_Screen> createState() => _Home_Page_ScreenState();
}

class _Home_Page_ScreenState extends State<Home_Page_Screen> {
  var services;
  getProfiledetail(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('register') != null) {
      email_profile = prefs.getString('register');
    } else {
      email_profile = prefs.getString('Login');
    }

    var response = await http
        .post(Uri.parse(url_userdetail), body: {'email': email_profile});
    print(response.body);
    var data = jsonDecode(response.body);
    setState(() {
      username = data[0]['name'].toString();

      var user_image_data = data[0]['Profile_Picture'];
      print(user_image_data);

      if (user_image_data == '') {
        user_image = null;
      } else if (user_image_data == null) {
        user_image = null;
      } else {
        user_image = File(data[0]['Profile_Picture']);
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(),
      ),
    );
  }

  Future<void> getplaces() async {
    try {
      var response = await http.get(Uri.parse(url_getdata));
      var data = await jsonDecode(response.body);
      setState(() {
        Salon_image = data;
      });

      for (int i = 0; i < Salon_image.length; i++) {
        searchedTerms.add(Salon_image[i]['search_address']);
      }
    } catch (e) {
      print(e);
    }
  }

  // getServices() async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         FirebaseFirestore.instance.collection('services').get();
  //     print('result:${querySnapshot}');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getplaces();
    // getServices();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0, top: 8.0),
                child: GestureDetector(
                    onTap: () {
                      // getProfiledetail(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) => Profile())));
                    },
                    child: Icon(
                      Icons.account_circle_sharp,
                      size: 50.0,
                    )),
              ),
            ],
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.vertical(
            //       bottom: Radius.circular(10),
            //     ),
            //   ),
            backgroundColor: Color.fromARGB(255, 44, 149, 254),
            title: Text('Salon App',
                style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold, fontSize: 25.0)),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg2.gif"), fit: BoxFit.cover)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Image(
                    height: 200,
                    width: 200,
                    image: AssetImage('images/logo2.png')),
                GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                    child: Material(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Center(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Search Service...',
                                style: GoogleFonts.ubuntu(fontSize: 15),
                              ),
                              Spacer(),
                              Container(
                                  height: 100,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Color.fromARGB(255, 91, 173, 255)),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('services')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error fetching data'),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final service = snapshot.data!.docs[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Salon_screen(service: service)));
                            },
                            child: Card(
                              shadowColor: Color.fromARGB(255, 0, 2, 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              color: kCardColor,
                              elevation: 4.0,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 140,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.fill,
                                            image:
                                                NetworkImage(service['image']),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Title:  ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  service['title'],
                                                  softWrap: false,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Price: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${service['price']}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: Salon_image.length,
                //     itemBuilder: (context, index) {
                //       return GestureDetector(
                //         onTap: () {
                //           salon_id = int.parse(Salon_image[index]['salonid']);
                //           String for_card = Salon_image[index]['salonid'];
                //           card_position = int.parse(for_card) - 1;
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const Salon_screen()));
                //         },
                //         child: Card(
                //           shadowColor: Color.fromARGB(255, 0, 2, 5),
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(20.0)),
                //           color: kCardColor,
                //           elevation: 4.0,
                //           child: Padding(
                //               padding: const EdgeInsets.all(10.0),
                //               child: Row(
                //                 children: [
                //                   Container(
                //                     height: 140,
                //                     width: 180,
                //                     child: ClipRRect(
                //                       borderRadius: BorderRadius.circular(10),
                //                       child: Image(
                //                         filterQuality: FilterQuality.high,
                //                         fit: BoxFit.fill,
                //                         image: NetworkImage(uploaded_images +
                //                             Salon_image[index]['image_name']),
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(
                //                     width: 30.0,
                //                   ),
                //                   Flexible(
                //                       child: RichText(
                //                     textAlign: TextAlign.center,
                //                     text: TextSpan(
                //                         text: Salon_image[index]['Name'],
                //                         style: GoogleFonts.ubuntu(
                //                             fontSize: 20, color: Colors.black),
                //                         children: [
                //                           TextSpan(
                //                               text: '\n\n' +
                //                                   Salon_image[index]['address'],
                //                               style: GoogleFonts.ubuntu(
                //                                   fontSize: 15.0,
                //                                   color: Colors.black))
                //                         ]),
                //                   )),
                //                 ],
                //               )),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //     backgroundColor: Color.fromARGB(255, 44, 149, 254),
        //     onPressed: () {
        //       // getServices();
        //       // getplaces();
        //     },
        //     label: Text(
        //       'Refresh',
        //       style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        //     ),
        //     icon: Icon(Icons.refresh)),
      ),
    );
  }
}
