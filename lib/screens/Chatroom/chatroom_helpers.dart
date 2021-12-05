import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Messaging/groupmessage.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChatroomHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late String chatroomAvatarUrl = "";
  late String chatroomId;
  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  String get getChatroomId => chatroomId;
  TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetails(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.27,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.blueColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Members",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                color: constantColors.transperant,
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.yellowColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Admins",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        backgroundImage: NetworkImage(
                          documentSnapshot['userimage'],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          documentSnapshot['username'],
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showCreateChatroomSheet({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Text(
                  "Select Chatroom Avatar",
                  style: TextStyle(
                    color: constantColors.greenColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("chatroomIcons")
                        .snapshots(),
                    builder: (context, chatroomIconSnaps) {
                      if (!chatroomIconSnaps.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: chatroomIconSnaps.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return InkWell(
                              onTap: () {
                                chatroomAvatarUrl = documentSnapshot['image'];
                                notifyListeners();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: getChatroomAvatarUrl ==
                                              documentSnapshot['image']
                                          ? constantColors.blueColor
                                          : constantColors.transperant,
                                    ),
                                  ),
                                  height: 15,
                                  width: 45,
                                  child: Image.network(
                                      documentSnapshot['image'],
                                      fit: BoxFit.contain),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: chatroomNameController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter Chatroom ID",
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          String chatroomIdName = nanoid(14).toString();
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .submitChatroomData(
                            chatroomName: chatroomIdName,
                            chatroomData: {
                              'chatroomid': chatroomIdName,
                              'roomAvatar': getChatroomAvatarUrl,
                              'time': Timestamp.now(),
                              'roomname': chatroomNameController.text,
                              'username': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'userimage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'useremail': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                            },
                          ).whenComplete(() {
                            Navigator.pop(context);
                          });
                        },
                        backgroundColor: constantColors.darkColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: constantColors.yellowColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showChatrooms({required BuildContext context}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("chatrooms").snapshots(),
      builder: (context, chatroomSnaps) {
        if (!chatroomSnaps.hasData) {
          return Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset("assets/animation/loading.json"),
            ),
          );
        } else {
          return ListView(
            children: chatroomSnaps.data!.docs
                .map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child:
                              GroupMessage(documentSnapshot: documentSnapshot),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () {
                  showChatroomDetails(
                      context: context, documentSnapshot: documentSnapshot);
                },
                title: Text(
                  documentSnapshot['roomname'],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  "2 hours ago",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 10,
                  ),
                ),
                subtitle: Text(
                  "Last message",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage: NetworkImage(documentSnapshot['roomAvatar']),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
