import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class AuctionAppHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget bodyImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.50,
        width: MediaQuery.of(context).size.width,
        child: Lottie.asset(
          "assets/animations/door.json",
        ),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.52,
      left: 10,
      right: 10,
      child: Column(
        children: [
          Text(
            "Some magical is lurking inside...",
            style: TextStyle(
              fontFamily: "Poppins",
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Mared Auctions, Coming Soon!",
            style: TextStyle(
              fontFamily: "Poppins",
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          LoadingWidget(constantColors: constantColors)
        ],
      ),
    );
  }
}
