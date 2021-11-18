import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [],
      ),
    );
  }
}
