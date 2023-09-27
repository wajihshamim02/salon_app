import 'package:app_hair/shopowner/customerpage.dart';
import 'package:app_hair/starting_screens/SpalshScreen.dart';
import 'package:app_hair/starting_screens/login/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Home_page/HomePage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: ThemeData.light(),
            // darkTheme: ThemeData.dark(),
            home: Splash_Screen_Screen());
      },
    );
  }
}
