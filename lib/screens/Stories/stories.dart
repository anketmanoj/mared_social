import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Stories extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const Stories({Key? key, required this.documentSnapshot}) : super(key: key);
  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  // @override
  // void initState() {
  //   Timer(
  //       Duration(seconds: 15),
  //       () => Navigator.pushReplacement(
  //             context,
  //             PageTransition(
  //                 child: const HomePage(),
  //                 type: PageTransitionType.topToBottom),
  //           ));
  //   super.initState();
  // }

  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (update) {
            if (update.delta.dx > 0) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const HomePage(),
                    type: PageTransitionType.topToBottom),
              );
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: widget.documentSnapshot['image'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 30,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.documentSnapshot['userimage'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.documentSnapshot['username'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                timeago.format((widget.documentSnapshot['time']
                                        as Timestamp)
                                    .toDate()),
                                style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            Provider.of<Authentication>(context, listen: false)
                                    .getUserId ==
                                widget.documentSnapshot['useruid'],
                        child: InkWell(
                          onTap: () {},
                          child: SizedBox(
                            height: 30,
                            width: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidEye,
                                  color: constantColors.yellowColor,
                                  size: 16,
                                ),
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularCountDownTimer(
                          isTimerTextShown: false,
                          width: 20,
                          height: 20,
                          duration: 15,
                          fillColor: constantColors.blueColor,
                          ringColor: constantColors.darkColor,
                        ),
                      ),
                      Visibility(
                        visible:
                            Provider.of<Authentication>(context, listen: false)
                                    .getUserId ==
                                widget.documentSnapshot['useruid'],
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: constantColors.blueGreyColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 150),
                                        child: Divider(
                                          thickness: 4,
                                          color: constantColors.whiteColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      constantColors.blueColor),
                                            ),
                                            icon: Icon(
                                              FontAwesomeIcons.archive,
                                              color: constantColors.whiteColor,
                                            ),
                                            onPressed: () {
                                              // * here
                                            },
                                            label: Text(
                                              "Add to highlights",
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          TextButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      constantColors.redColor),
                                            ),
                                            icon: Icon(
                                              FontAwesomeIcons.trashAlt,
                                              color: constantColors.whiteColor,
                                            ),
                                            onPressed: () {
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.warning,
                                                title: "Delete Story?",
                                                text:
                                                    "Are you sure you want to delete this story?",
                                                showCancelBtn: true,
                                                cancelBtnText: "No",
                                                confirmBtnText: "Yes",
                                                onCancelBtnTap: () =>
                                                    Navigator.pop(context),
                                                onConfirmBtnTap: () async {
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("stories")
                                                        .doc(widget
                                                            .documentSnapshot
                                                            .id)
                                                        .delete()
                                                        .whenComplete(() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("users")
                                                          .doc(Provider.of<
                                                                      Authentication>(
                                                                  context,
                                                                  listen: false)
                                                              .getUserId)
                                                          .collection("stories")
                                                          .doc(widget
                                                              .documentSnapshot
                                                              .id)
                                                          .delete()
                                                          .whenComplete(() {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          PageTransition(
                                                              child:
                                                                  const HomePage(),
                                                              type: PageTransitionType
                                                                  .topToBottom),
                                                        );
                                                      });
                                                    });
                                                  } catch (e) {
                                                    CoolAlert.show(
                                                      context: context,
                                                      type: CoolAlertType.error,
                                                      title:
                                                          "Delete Story Failed",
                                                      text: e.toString(),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                            label: Text(
                                              "Delete Story",
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(
                            EvaIcons.moreVertical,
                            color: constantColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
