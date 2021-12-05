import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask? imageUploadTask;
  late String initUserEmail, initUserName, initUserImage;

  String get getInitUserImage => initUserImage;
  String get getInitUserEmail => initUserEmail;
  String get getInitUserName => initUserName;

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
      print(initUserName);
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection("posts").doc(postId).set(data);
  }

  Future deleteUserData(String userUid) async {
    return FirebaseFirestore.instance.collection('users').doc(userUid).delete();
  }

  Future deletePostData({String? postId}) async {
    return await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete();
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
      {required String postId, String? description}) async {
    return FirebaseFirestore.instance.collection("posts").doc(postId).update({
      'description': description,
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
}
