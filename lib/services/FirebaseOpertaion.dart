import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/services/fcm_notification_Service.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask? imageUploadTask;
  late String initUserEmail, initUserName, initUserImage;
  late bool store;
  late String fcmToken;
  int? unReadMsgs;

  int? get getUnReadMsgs => unReadMsgs;
  bool get getStore => store;
  String get getFcmToken => fcmToken;
  String get getInitUserImage => initUserImage;
  String get getInitUserEmail => initUserEmail;
  String get getInitUserName => initUserName;

  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        "userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}");
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask!.whenComplete(
      () {
        print("Image uploaded!");
      },
    );
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          "The user profile avatar url => ${Provider.of<LandingUtils>(context, listen: false).userAvatarUrl}");
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((doc) {
      print("fetching user data");
      initUserName = doc['username'];
      initUserEmail = doc['useremail'];
      initUserImage = doc['userimage'];
      store = doc['store'];
      fcmToken = doc['fcmToken'];
      print(initUserName);
      notifyListeners();
    });
  }

  Future initChatData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .collection("chats")
        .get()
        .then((chats) async {
      chats.docs.forEach((chat) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(Provider.of<Authentication>(context, listen: false).getUserId)
            .collection("chats")
            .doc(chat.id)
            .collection("messages")
            .where("msgSeen", isEqualTo: false)
            .get()
            .then((messages) async {
          print("${messages.docs.length} here");
          unReadMsgs = messages.docs.length;
          notifyListeners();
        });
      });
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection("posts").doc(postId).set(data);
  }

  Future deleteUserData(String userUid) async {
    return FirebaseFirestore.instance.collection('users').doc(userUid).delete();
  }

  Future deletePostData(
      {required String postId, required String userUid}) async {
    return await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete()
        .whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection("posts")
          .doc(postId)
          .delete();
    });
  }

  Future deleteUserComment(
      {required String postId, required String commentId}) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .delete();
  }

  Future addAward({required String postId, required dynamic data}) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("awards")
        .add(data);
  }

  Future updateDescription(
      {required String postId,
      required AsyncSnapshot<DocumentSnapshot> postDoc,
      String? description,
      required BuildContext context}) async {
    String name = "${postDoc.data!['caption']} ${description}";

    List<String> splitList = name.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length; j++) {
        indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
      }
    }
    return await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .update({
      'description': description,
      'searchindex': indexList,
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(Provider.of<Authentication>(context, listen: false).getUserId)
          .collection("posts")
          .doc(postId)
          .update({
        'description': description,
        'searchindex': indexList,
      });
    });
  }

  Future followUser({
    required String followingUid,
    required String followingDocId,
    required dynamic followingData,
    required String followerUid,
    required String followerDocId,
    required dynamic followerData,
  }) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(followingUid)
        .collection("followers")
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(followerUid)
          .collection("following")
          .doc(followerDocId)
          .set(followerData);
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(followingUid)
          .get()
          .then((postUser) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(followerUid)
            .get()
            .then((followingUser) async {
          await _fcmNotificationService.sendNotificationToUser(
              to: postUser['fcmToken']!, //To change once set up
              title: "${followingUser['username']} follows you",
              body: "");
        });
      });
    });
  }

  Future submitChatroomData({
    required String chatroomName,
    required dynamic chatroomData,
  }) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomName)
        .set(chatroomData);
  }

  Future messageUser({
    required String messagingUid,
    required String messagingDocId,
    required dynamic messagingData,
    required String messengerUid,
    required String messengerDocId,
    required dynamic messengerData,
  }) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(messagingUid)
        .collection("chats")
        .doc(messagingDocId)
        .set(messagingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(messengerUid)
          .collection("chats")
          .doc(messengerDocId)
          .set(messengerData);
    });
  }

  Future deleteMessage(
      {required String chatroomId, required String messageId}) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  List<String> catNames = [
    'Sports',
    'Services',
    'Events',
    'Homemade',
    'Furniture',
    'Education',
    'Fashion & Beauty',
    'Electronics',
    'Business & Industry',
    'Healthcare',
    'Jobs',
    'Real Estate',
    'Automobiles'
  ];
}
