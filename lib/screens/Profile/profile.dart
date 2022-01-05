import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();

  Profile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: "My ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Profile",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.darkColor,
        onPressed: () {
          Provider.of<ProfileHelpers>(context, listen: false)
              .postSelectType(context: context);
        },
        child: Stack(
          children: [
            Center(
              child: Icon(
                EvaIcons.plusCircleOutline,
                color: constantColors.whiteColor,
              ),
            ),
            Lottie.asset("assets/animations/cool.json"),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.43,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: constantColors.blueGreyColor,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .headerProfile(context, snapshot),
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .divider(),
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .middleProfile(context, snapshot),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserId)
                .collection("posts")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, userPostSnap) {
              return SliverPadding(
                padding: const EdgeInsets.all(4),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index.toInt() < userPostSnap.data!.docs.length) {
                        var userPostDocSnap = userPostSnap.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            Provider.of<ProfileHelpers>(context, listen: false)
                                .showPostDetail(
                                    context: context,
                                    documentSnapshot: userPostDocSnap);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: userPostDocSnap['imageslist']
                                          [index],
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: LoadingWidget(
                                            constantColors: constantColors),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    );
                                  },
                                  itemCount:
                                      (userPostDocSnap['imageslist'] as List)
                                          .length,
                                  itemHeight:
                                      MediaQuery.of(context).size.height * 0.3,
                                  itemWidth: MediaQuery.of(context).size.width,
                                  layout: SwiperLayout.DEFAULT,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
