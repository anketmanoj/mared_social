import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Profile/profile.dart';
import 'package:mared_social/screens/auctionFeed/auctionFeed.dart';
import 'package:mared_social/screens/auctionMap/auctionMapScreen.dart';
import 'package:mared_social/screens/auctions/auctionPageHelper.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({Key? key}) : super(key: key);

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  final PageController auctionAppController = PageController();
  int pageIndex = 0;
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Provider.of<AuctionAppHelper>(context, listen: false)
          .bottomNavBar(context, pageIndex, auctionAppController),
      body: PageView(
        controller: auctionAppController,
        children: [
          AuctionFeed(),
          AuctionMap(),
          Provider.of<Authentication>(context, listen: false).getIsAnon == false
              ? Profile()
              : IsAnonMsg(),
        ],
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
    );
  }
}
