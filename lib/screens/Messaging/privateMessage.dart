import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/Messaging/privateMessageHelper.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PrivateMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const PrivateMessage({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _PrivateMessageState createState() => _PrivateMessageState();
}

class _PrivateMessageState extends State<PrivateMessage> {
  ConstantColors constantColors = ConstantColors();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(EvaIcons.logInOutline, color: constantColors.redColor),
          ),
          Provider.of<Authentication>(context, listen: false).getUserId ==
                  widget.documentSnapshot['useruid']
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: constantColors.whiteColor,
                  ),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const HomePage(),
                    type: PageTransitionType.rightToLeft));
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
        ),
        backgroundColor: constantColors.darkColor,
        centerTitle: false,
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage:
                    NetworkImage(widget.documentSnapshot['userimage']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.documentSnapshot['username'],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                color: constantColors.darkColor,
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: const Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: Provider.of<PrivateMessageHelper>(context, listen: false)
                    .showMessages(
                        context: context,
                        documentSnapshot: widget.documentSnapshot,
                        adminUserUid: widget.documentSnapshot['useruid']),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: constantColors.blueGreyColor,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          backgroundImage:
                              AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: "Drop a hi...",
                              hintStyle: TextStyle(
                                color: constantColors.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: constantColors.blueColor,
                        onPressed: () async {
                          String messageId = nanoid(14).toString();
                          // await Provider.of<PrivateMessageHelper>(context,
                          //         listen: false)
                          //     .sendMessage(
                          //   context: context,
                          //   documentSnapshot: widget.documentSnapshot,
                          //   messagecontroller: messageController,
                          //   messageId: messageId,
                          // );

                          // await Provider.of<GroupMessageHelper>(context,
                          //         listen: false)
                          //     .updateTime(
                          //         documentSnapshot: widget.documentSnapshot);

                          messageController.clear();
                        },
                        child: Icon(
                          Icons.send_sharp,
                          color: constantColors.whiteColor,
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
