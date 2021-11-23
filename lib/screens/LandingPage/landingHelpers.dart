import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

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
                    onTap: () => emailAuthSheet(context),
                  ),
                  LoginIcon(
                    icon: EvaIcons.google,
                    color: constantColors.greenColor,
                    onTap: () async {
                      try {
                        await Provider.of<Authentication>(context,
                                listen: false)
                            .signInWithgoogle();

                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: HomePage(),
                                type: PageTransitionType.rightToLeft));
                      } catch (e) {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          title: "Sign In Failed",
                          text: e.toString(),
                        );
                      }
                    },
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
                    onTap: () => emailAuthSheet(context),
                  ),
                  LoginIcon(
                    icon: EvaIcons.google,
                    color: constantColors.greenColor,
                    onTap: () {
                      Provider.of<Authentication>(context, listen: false)
                          .signInWithgoogle()
                          .whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: HomePage(),
                                type: PageTransitionType.rightToLeft));
                      });
                    },
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

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Provider.of<LandingService>(context, listen: false)
                  .passwordlessSignIn(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: constantColors.blueColor,
                    onPressed: () {
                      Navigator.pop(context);
                      Provider.of<LandingService>(context, listen: false)
                          .loginSheet(context);
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: constantColors.redColor,
                    onPressed: () {
                      Navigator.pop(context);
                      Provider.of<LandingUtils>(context, listen: false)
                          .selectAvatarOptionsSheet(context);
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
        );
      },
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
