import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/LandingPage/landingHelpers.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingHelpers>(context, listen: false)
              .bodyImage(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .taglineText(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .mainButton(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .exploreApp(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .privacyText(context),
        ],
      ),
    );
  }

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
}
