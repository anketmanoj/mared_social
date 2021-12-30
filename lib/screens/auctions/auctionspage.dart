import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/auctions/auctionPageHelper.dart';
import 'package:provider/provider.dart';

class AuctionPage extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  bodyColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.5, 0.9],
          colors: [
            constantColors.darkColor,
            constantColors.blueGreyColor,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<AuctionAppHelper>(context, listen: false)
              .bodyImage(context),
          Provider.of<AuctionAppHelper>(context, listen: false)
              .taglineText(context),
        ],
      ),
    );
  }
}
