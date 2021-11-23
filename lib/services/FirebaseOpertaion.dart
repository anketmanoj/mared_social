import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  Future uploadUserAvatar(BuildContext context) async {
    UploadTask imageUploadTask;
    Reference imageReference = FirebaseStorage.instance.ref().child(
        "userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}");
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(
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
}
