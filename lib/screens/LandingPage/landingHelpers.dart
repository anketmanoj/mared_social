import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.png"),
        ),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      top: 500,
      left: 10,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 190,
        ),
        child: RichText(
          text: TextSpan(
              text: "Connecting\n",
              style: TextStyle(
                fontFamily: "Poppins",
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Businesses\n",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                TextSpan(
                  text: "In UAE",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0,
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: 700,
      right: 10,
      left: 10,
      child: Platform.isIOS
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoginIcon(
                    icon: EvaIcons.emailOutline,
                    color: constantColors.yellowColor,
                  ),
                  LoginIcon(
                    icon: EvaIcons.google,
                    color: constantColors.greenColor,
                  ),
                  LoginIcon(
                    icon: EvaIcons.facebook,
                    color: constantColors.blueColor,
                  ),
                  LoginIcon(
                      icon: FontAwesomeIcons.apple,
                      color: constantColors.whiteColor)
                ],
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoginIcon(
                    icon: EvaIcons.emailOutline,
                    color: constantColors.yellowColor,
                  ),
                  LoginIcon(
                    icon: EvaIcons.google,
                    color: constantColors.greenColor,
                  ),
                  LoginIcon(
                    icon: EvaIcons.facebook,
                    color: constantColors.blueColor,
                  ),
                ],
              ),
            ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: 780,
      left: 20,
      right: 20,
      child: Column(
        children: const [
          Text(
            "By continuing you agree to Mareds Terms of",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            "Services & Privacy Policy",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginIcon extends StatelessWidget {
  const LoginIcon({
    Key? key,
    required this.color,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Icon(icon, color: color),
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
