// ignore: file_names
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConstantColors {
  final Color lightColor = const Color(0xff6c788a);
  final Color darkColor = const Color(0xFF100E20);
  final Color blueColor = Colors.lightBlueAccent.shade400;
  final Color lightBlueColor = Colors.lightBlueAccent.shade200;
  final Color redColor = Colors.red;
  final Color whiteColor = Colors.white;
  final Color blueGreyColor = Colors.blueGrey.shade900;
  final Color greenColor = Colors.greenAccent;
  final Color yellowColor = Colors.yellow;
  final Color transperant = Colors.transparent;
  final Color greyColor = Colors.grey.shade600;
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    required this.constantColors,
  }) : super(key: key);

  final ConstantColors constantColors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height * 0.236,
              width: MediaQuery.of(context).size.width * 0.717,
              color: constantColors.transperant,
              child: Image.asset("assets/animations/lamp.png")),
          Lottie.asset(
            "assets/animations/smoke.json",
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width * 0.15,
          )
        ],
      ),
    );
  }
}
