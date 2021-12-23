import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:mared_social/screens/Categories/categoryHelpers.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeedhelper.dart';
import 'package:mared_social/screens/Chatroom/chatroom_helpers.dart';
import 'package:mared_social/screens/Chatroom/privateChatHelpers.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/HomePage/homepageHelpers.dart';
import 'package:mared_social/screens/LandingPage/landingHelpers.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/screens/Messaging/groupmessagehelper.dart';
import 'package:mared_social/screens/Messaging/privateMessageHelper.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/screens/SearchFeed/searchfeedhelper.dart';
import 'package:mared_social/screens/Stories/stories_helper.dart';
import 'package:mared_social/screens/isAnon/isAnonHelper.dart';
import 'package:mared_social/screens/mapscreen/category_mapscreenhelper.dart';
import 'package:mared_social/screens/mapscreen/mapscreenhelper.dart';
import 'package:mared_social/screens/splashscreens/splashscreen.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title

    importance: Importance.max,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;

  //   // If `onMessage` is triggered with a notification, construct our own
  //   // local notification to show to users using the created channel.
  //   if (notification != null && android != null) {
  //     try {
  //       flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               channel.id,
  //               channel.name,

  //               icon: android.smallIcon,
  //               // other properties...
  //             ),
  //           ));
  //     } on Exception catch (e) {
  //       print("ERROR ANKET ==== ${e.toString()}");
  //       // TODO
  //     }
  //   }
  // });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
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
        ChangeNotifierProvider(create: (_) => IsAnonHelper()),
        ChangeNotifierProvider(create: (_) => CategoryMapScreenHelper()),
        ChangeNotifierProvider(create: (_) => MapScreenHelper()),
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => HomepageHelpers()),
        ChangeNotifierProvider(create: (_) => ProfileHelpers()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(create: (_) => PostFunctions()),
        ChangeNotifierProvider(create: (_) => AltProfileHelper()),
        ChangeNotifierProvider(create: (_) => ChatroomHelpers()),
        ChangeNotifierProvider(create: (_) => GroupMessageHelper()),
        ChangeNotifierProvider(create: (_) => CategoryHelper()),
        ChangeNotifierProvider(create: (_) => StoriesHelper()),
        ChangeNotifierProvider(create: (_) => CatgeoryFeedHelper()),
        ChangeNotifierProvider(create: (_) => SearchFeedHelper()),
        ChangeNotifierProvider(create: (_) => PrivateChatHelpers()),
        ChangeNotifierProvider(create: (_) => PrivateMessageHelper()),
      ],
    );
  }
}
