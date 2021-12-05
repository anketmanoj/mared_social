import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';

class GroupMessageHelper with ChangeNotifier {
  sendMessage(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot,
      required TextEditingController messagecontroller}) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(documentSnapshot.id)
        .collection("messages")
        .add({
      'message': messagecontroller.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
    });
  }
}
