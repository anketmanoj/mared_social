import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late File uploadPostImage;
  late String uploadPostImageUrl;

  File get getUploadPostImage => uploadPostImage;
  String get getUploadPostImageUrl => uploadPostImageUrl;

  final picker = ImagePicker();
  late UploadTask imagePostUploadTask;

  TextEditingController captionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        // ignore: avoid_print
        ? print("select image")
        : uploadPostImage = File(uploadPostImageVal.path);
    // ignore: avoid_print
    print(uploadPostImage.path);

    // ignore: unnecessary_null_comparison
    uploadPostImage != null
        ? showPostImage(context)
        : print("Image upload error");

    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      "Gallery",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      pickUploadPostImage(
                        context,
                        ImageSource.gallery,
                      );
                    },
                  ),
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      "Camera",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      pickUploadPostImage(
                        context,
                        ImageSource.camera,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 8,
                ),
                child: Container(
                  height: 300,
                  width: 300,
                  child: Image.file(
                    uploadPostImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      child: Text(
                        "Reselect",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: constantColors.whiteColor,
                        ),
                      ),
                      onPressed: () {
                        selectPostImageType(context);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        "Confirm Image",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        uploadPostImageToFirebase().whenComplete(() {
                          editPostSheet(context);
                          print("image uploaded");
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');

    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print("Post image uploaded to storage");
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
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
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.image_aspect_ratio,
                              color: constantColors.greenColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.fit_screen,
                              color: constantColors.yellowColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 300,
                      child: Image.file(
                        uploadPostImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          height: 50,
                          width: 330,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLength: 50,
                            controller: captionController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: "Give your picture a title...",
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        height: 120,
                        width: 330,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(200)
                          ],
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          maxLength: 200,
                          controller: descriptionController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: "Give your picture a caption...",
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                child: Text(
                  "Share",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onPressed: () async {
                  String postId = nanoid(14).toString();
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .uploadPostData(postId, {
                    'postid': postId,
                    'caption': captionController.text,
                    'username':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserName,
                    'userimage':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserImage,
                    'useruid':
                        Provider.of<Authentication>(context, listen: false)
                            .getUserId,
                    'time': Timestamp.now(),
                    'useremail':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserEmail,
                    'postimage':
                        uploadPostImageUrl, //or chnage to getUploadPostImageUrl
                    'description': descriptionController.text,
                  }).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                color: constantColors.blueColor,
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}
