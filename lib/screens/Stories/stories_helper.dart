import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/screens/Stories/stories_widget.dart';

class StoriesHelper with ChangeNotifier {
  final picker = ImagePicker();
  late UploadTask imageUploadTask;
  late File storyImage;
  File get getStoryImage => storyImage;
  final StoryWidgets storyWidgets = StoryWidgets();
  late String storyImageUrl;
  String get getStoryImageUrl => storyImageUrl;

  Future selectStoryImage(
      {required BuildContext context, required ImageSource source}) async {
    final pickedStoryImage = await picker.pickImage(source: source);
    pickedStoryImage == null
        ? print("Error")
        : storyImage = File(pickedStoryImage.path);

    // ignore: unnecessary_null_comparison
    storyImage != null
        ? storyWidgets.previewStoryImage(
            context: context, storyImage: storyImage)
        : print("Error");

    notifyListeners();
  }

  Future uploadStoryImage({required BuildContext context}) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage.path}/${Timestamp.now()}');

    imageUploadTask = imageReference.putFile(getStoryImage);
    await imageUploadTask.whenComplete(() {
      print("story image uploaded");
    });
    imageReference.getDownloadURL().then((url) {
      storyImageUrl = url;
      print(storyImageUrl);
    });
    notifyListeners();
  }
}
