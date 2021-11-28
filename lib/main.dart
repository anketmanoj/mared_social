import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/HomePage/homepageHelpers.dart';
import 'package:mared_social/screens/LandingPage/landingHelpers.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/screens/splashscreens/splashscreen.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: constantColors.blueColor,
          fontFamily: "Poppins",
          canvasColor: Colors.transparent,
        ),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => HomepageHelpers()),
        ChangeNotifierProvider(create: (_) => ProfileHelpers()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
      ],
    );
  }
}
