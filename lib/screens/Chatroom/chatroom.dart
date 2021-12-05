import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Chatroom/chatroom_helpers.dart';
import 'package:provider/provider.dart';

class Chatroom extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ChatroomHelpers>(context, listen: false)
              .showCreateChatroomSheet(context: context);
        },
        backgroundColor: constantColors.blueGreyColor,
        child: Icon(
          FontAwesomeIcons.plus,
          color: constantColors.greenColor,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: constantColors.darkColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.whiteColor,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            FontAwesomeIcons.plus,
            color: constantColors.greenColor,
          ),
        ),
        title: RichText(
          text: TextSpan(
            text: "Mared ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Chatroom",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatroomHelpers>(context, listen: false)
            .showChatrooms(context: context),
      ),
    );
  }
}
