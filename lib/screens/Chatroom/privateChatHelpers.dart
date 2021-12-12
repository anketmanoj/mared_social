import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Messaging/privateMessage.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PrivateChatHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  showChatrooms({required BuildContext context, required String userUid}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection("chats")
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, chatroomSnaps) {
        if (chatroomSnaps.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset("assets/animation/loading.json"),
            ),
          );
        } else if (chatroomSnaps.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No Chats Yet",
              style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return ListView(
            children: chatroomSnaps.data!.docs
                .map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: PrivateMessage(
                              documentSnapshot: documentSnapshot),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () {},
                title: Text(
                  documentSnapshot['username'],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  timeago
                      .format((documentSnapshot['time'] as Timestamp).toDate()),
                  style: TextStyle(
                    color: constantColors.greenColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserId)
                        .collection("chats")
                        .doc(documentSnapshot.id)
                        .collection("messages")
                        .orderBy('time', descending: true)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return Text(
                            snapshot.data!.docs[0]['message']
                                    .toString()
                                    .isNotEmpty
                                ? "${snapshot.data!.docs[0]['username']}: ${snapshot.data!.docs[0]['message']}"
                                : "${snapshot.data!.docs[0]['username']}: Sticker",
                            style: TextStyle(
                              color: constantColors.greenColor,
                              fontSize: 10,
                            ),
                          );
                        } else {
                          return Text(
                            "",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 10,
                            ),
                          );
                        }
                      } catch (e) {
                        return Center(
                          child: Text(e.toString()),
                        );
                      }
                    }),
                leading: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage: NetworkImage(documentSnapshot['userimage']),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
