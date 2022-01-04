import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/auctionoptions.dart';
import 'package:provider/provider.dart';

class AuctionPage extends StatefulWidget {
  final String auctionId;

  const AuctionPage({Key? key, required this.auctionId}) : super(key: key);
  @override
  _AuctionPageState createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  ConstantColors constantColors = ConstantColors();
  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("auctions")
          .doc(widget.auctionId)
          .snapshots(),
      builder: (context, auctionDoc) {
        DocumentSnapshot auctionDocSnap = auctionDoc.data!;
        Provider.of<AuctionFuctions>(context, listen: false).addAuctionView(
            userUid: auctionDocSnap['useruid'],
            context: context,
            auctionID: auctionDocSnap['auctionid'],
            subDocId:
                Provider.of<Authentication>(context, listen: false).getUserId);
        return Scaffold(
          backgroundColor: constantColors.blueGreyColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: constantColors.darkColor,
                    )),
                backgroundColor: constantColors.blueGreyColor,
                expandedHeight: size.height * 0.35,
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    top: true,
                    child: Container(
                      color: constantColors.darkColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Swiper(
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: auctionDocSnap['imageslist'][index],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
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
                              (auctionDocSnap['imageslist'] as List).length,
                          itemHeight: MediaQuery.of(context).size.height * 0.3,
                          itemWidth: MediaQuery.of(context).size.width,
                          layout: SwiperLayout.DEFAULT,
                          indicatorLayout: PageIndicatorLayout.SCALE,
                          pagination: SwiperPagination(
                            margin: const EdgeInsets.all(10),
                            builder: DotSwiperPaginationBuilder(
                              color: constantColors.whiteColor.withOpacity(0.6),
                              activeColor:
                                  constantColors.darkColor.withOpacity(0.6),
                              size: 15,
                              activeSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getIsAnon ==
                                    false) {
                                  Provider.of<AuctionFuctions>(context,
                                          listen: false)
                                      .addAuctionLike(
                                    userUid: auctionDocSnap['useruid'],
                                    context: context,
                                    auctionID: auctionDocSnap['auctionid'],
                                    subDocId: Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserId,
                                  );
                                } else {
                                  Provider.of<FeedHelpers>(context,
                                          listen: false)
                                      .IsAnonBottomSheet(context);
                                }
                              },
                              onLongPress: () {
                                Provider.of<AuctionFuctions>(context,
                                        listen: false)
                                    .showLikes(
                                        context: context,
                                        auctionId: auctionDocSnap['auctionid']);
                              },
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("auctions")
                                      .doc(auctionDocSnap['auctionid'])
                                      .collection('likes')
                                      .snapshots(),
                                  builder: (context, likeSnap) {
                                    return SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                likeSnap.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            InkWell(
                              onTap: () {
                                Provider.of<AuctionFuctions>(context,
                                        listen: false)
                                    .showCommentsSheet(
                                        snapshot: auctionDocSnap,
                                        context: context,
                                        auctionId: auctionDocSnap['auctionid']);
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
                                        size: 20,
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("auctions")
                                            .doc(auctionDocSnap['auctionid'])
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, commentSnap) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              commentSnap.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Provider.of<AuctionFuctions>(context,
                                        listen: false)
                                    .showLikes(
                                        context: context,
                                        auctionId: auctionDocSnap['auctionid']);
                              },
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("auctions")
                                      .doc(auctionDocSnap['auctionid'])
                                      .collection('views')
                                      .snapshots(),
                                  builder: (context, viewSnap) {
                                    return SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.eye,
                                              color: constantColors.whiteColor,
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                viewSnap.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
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
}
