import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/auctionFeed/auctionfeedHelper.dart';
import 'package:provider/provider.dart';

class AuctionFeed extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: constantColors.blueGreyColor,
      floatingActionButton:
          Provider.of<AuctionFeedHelper>(context, listen: false)
              .postAuction(context),
    );
  }
}
