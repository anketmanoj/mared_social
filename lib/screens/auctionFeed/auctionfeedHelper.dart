import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/auctionFeed/createAuctionScreen.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AuctionFeedHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget postAuction(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: constantColors.darkColor,
      onPressed: () {
        Navigator.push(
            context,
            PageTransition(
                child: CreateAuctionScreen(),
                type: PageTransitionType.rightToLeft));
      },
      label: Text(
        "Post Auction",
        style: TextStyle(
          color: constantColors.whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      icon: Lottie.asset(
        "assets/animations/gavel.json",
        height: 20,
      ),
    );
  }
}
