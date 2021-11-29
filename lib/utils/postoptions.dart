import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  Future addLike({
    required BuildContext context,
    required String postID,
    required String subDocId,
  }) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  Future addComment({
    required String postId,
    required String comment,
    required BuildContext context,
  }) async {
    String commentId = nanoid(14).toString();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set({
      'commentid': commentId,
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserId,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  showCommentsSheet({
    required BuildContext context,
    required DocumentSnapshot snapshot,
    required String postId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
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
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.whiteColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Comments",
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection("comments")
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, commentSnap) {
                      if (commentSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: commentSnap.data!.docs
                              .map((DocumentSnapshot commentDocSnap) {
                            return Container(
                              color: constantColors.blueGreyColor,
                              height:
                                  MediaQuery.of(context).size.height * 0.135,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: GestureDetector(
                                          child: Container(
                                            // color: constantColors.darkColor,
                                            height: 30,
                                            width: 30,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    commentDocSnap['userimage'],
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  commentDocSnap['username'],
                                                  style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(FontAwesomeIcons.arrowUp,
                                                size: 14,
                                                color:
                                                    constantColors.blueColor),
                                          ),
                                          Text(
                                            "0",
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(FontAwesomeIcons.reply,
                                                size: 14,
                                                color:
                                                    constantColors.yellowColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: constantColors.blueColor,
                                            size: 14,
                                          ),
                                          onPressed: () {},
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: Text(
                                            commentDocSnap['comment'],
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Provider.of<Authentication>(context,
                                                        listen: false)
                                                    .getUserId ==
                                                commentDocSnap['useruid']
                                            ? IconButton(
                                                onPressed: () {
                                                  Provider.of<FirebaseOperations>(
                                                          context,
                                                          listen: false)
                                                      .deleteUserComment(
                                                          postId: postId,
                                                          commentId:
                                                              commentDocSnap[
                                                                  'commentid']);
                                                },
                                                icon: Icon(
                                                    FontAwesomeIcons.trashAlt,
                                                    size: 14,
                                                    color: constantColors
                                                        .redColor),
                                              )
                                            : const SizedBox(
                                                height: 0,
                                                width: 0,
                                              ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: constantColors.darkColor
                                        .withOpacity(0.2),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 300,
                        height: 30,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Add your opnion...',
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          controller: commentController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.greenColor,
                        child: Icon(
                          FontAwesomeIcons.comment,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          print("Adding Comment....");
                          addComment(
                                  postId: snapshot['postid'],
                                  comment: commentController.text,
                                  context: context)
                              .whenComplete(() {
                            commentController.clear();
                            notifyListeners();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  showLikes({required BuildContext context, required String postId}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
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
              Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.whiteColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    "Likes",
                    style: TextStyle(
                      color: constantColors.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(postId)
                      .collection("likes")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                          return ListTile(
                            leading: InkWell(
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: documentSnapshot['userimage'],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              documentSnapshot['username'],
                              style: TextStyle(
                                color: constantColors.blueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              documentSnapshot['useremail'],
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            trailing: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId ==
                                    documentSnapshot['useruid']
                                ? const SizedBox(
                                    height: 0,
                                    width: 0,
                                  )
                                : MaterialButton(
                                    child: Text("Follow",
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                    onPressed: () {},
                                    color: constantColors.blueColor,
                                  ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showRewards(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
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
              Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.whiteColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    "Rewards",
                    style: TextStyle(
                      color: constantColors.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("awards")
                        .snapshots(),
                    builder: (context, awardSnap) {
                      if (awardSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                            scrollDirection: Axis.horizontal,
                            children: awardSnap.data!.docs
                                .map((DocumentSnapshot awardDocSnap) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(awardDocSnap['image']),
                                ),
                              );
                            }).toList());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
