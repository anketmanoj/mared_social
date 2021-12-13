import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Categories/category.dart';
import 'package:mared_social/screens/Chatroom/chatroom.dart';
import 'package:mared_social/screens/Feed/feed.dart';
import 'package:mared_social/screens/HomePage/homepageHelpers.dart';
import 'package:mared_social/screens/Profile/profile.dart';
import 'package:mared_social/screens/mapscreen/mapscreen.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();

  int pageIndex = 0;
  bool loading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<FirebaseOperations>(context, listen: false)
          .initUserData(context)
          .whenComplete(() {
        setState(() {
          loading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Initializing Mared",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          : PageView(
              controller: homepageController,
              children: [
                Feed(),
                CategoryScreen(),
                Chatroom(),
                MapScreen(),
                Profile(),
              ],
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() {
                  pageIndex = page;
                });
              },
            ),
      bottomNavigationBar: Provider.of<HomepageHelpers>(context, listen: false)
          .bottomNavBar(context, pageIndex, homepageController),
    );
  }
}
