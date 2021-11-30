import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.8),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false)
                .selectPostImageType(context);
          },
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: constantColors.greenColor,
          ),
        ),
      ],
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
              text: "Feed",
              style: TextStyle(
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 500,
                    width: 400,
                    child: Lottie.asset("assets/animations/loading.json"),
                  ),
                );
              } else {
                return loadPosts(context, snapshot);
              }
            },
          ),
          height: MediaQuery.of(context).size.height * 0.77,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: documentSnapshot['userimage'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                documentSnapshot['caption'],
                                style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: RichText(
                                text: TextSpan(
                                    text: documentSnapshot['username'],
                                    style: TextStyle(
                                      color: constantColors.blueColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: " , 12 hours ago",
                                          style: TextStyle(
                                            color: constantColors.lightColor
                                                .withOpacity(0.8),
                                          )),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onDoubleTap: () {
                    print("Adding like...");
                    Provider.of<PostFunctions>(context, listen: false).addLike(
                      context: context,
                      postID: documentSnapshot['postid'],
                      subDocId:
                          Provider.of<Authentication>(context, listen: false)
                              .getUserId,
                    );
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.46,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: documentSnapshot['postimage'],
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Container(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showLikes(
                                  context: context,
                                  postId: documentSnapshot['postid']);
                        },
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("posts")
                                .doc(documentSnapshot['postid'])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, likeSnap) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return SizedBox(
                                  width: 60,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          likeSnap.data!.docs.any((element) =>
                                                  element.id ==
                                                  Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserId)
                                              ? EvaIcons.heart
                                              : EvaIcons.heartOutline,
                                          color: constantColors.redColor,
                                          size: 18,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            likeSnap.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showCommentsSheet(
                                  snapshot: documentSnapshot,
                                  context: context,
                                  postId: documentSnapshot['postid']);
                        },
                        child: SizedBox(
                          width: 60,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.comment,
                                  color: constantColors.blueColor,
                                  size: 16,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(documentSnapshot['postid'])
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (context, commentSnap) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          commentSnap.data!.docs.length
                                              .toString(),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showRewards(
                                  context: context,
                                  postId: documentSnapshot['postid']);
                        },
                        child: SizedBox(
                          width: 60,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.award,
                                  color: constantColors.yellowColor,
                                  size: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("posts")
                                        .doc(documentSnapshot['postid'])
                                        .collection('awards')
                                        .snapshots(),
                                    builder: (context, awardSnap) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            awardSnap.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserId ==
                              documentSnapshot['useruid']
                          ? IconButton(
                              onPressed: () {},
                              icon: Icon(EvaIcons.moreVertical,
                                  color: constantColors.whiteColor),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 5,
                ),
                child: SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    documentSnapshot['description'],
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
