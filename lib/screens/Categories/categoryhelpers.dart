import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class CategoryHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController searchController = TextEditingController();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.blueGreyColor,
      centerTitle: true,
      leading: const SizedBox(
        height: 0,
        width: 0,
      ),
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
              text: "Categories",
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

  Widget headerCategory({required BuildContext context}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      color: constantColors.blueGreyColor,
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("categoryHeader")
                .limit(1)
                .snapshots(),
            builder: (context, headerSnap) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: headerSnap.data!.docs[0]['image'],
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 16,
            left: 16,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: constantColors.whiteColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    EvaIcons.searchOutline,
                    color: constantColors.darkColor,
                    size: 20,
                  ),
                  hintText: "Describe what you're looking for...",
                  hintStyle:
                      TextStyle(color: constantColors.darkColor, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget middleCategory({required BuildContext context}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("category").snapshots(),
      builder: (context, catSnaps) {
        if (catSnaps.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.0,
                children: catSnaps.data!.docs.map(
                  (catDocSnap) {
                    return InkWell(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: constantColors.blueColor,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 90,
                                width: 90,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: catDocSnap['categoryimage'],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            SizedBox(
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
                          ),
                          Positioned(
                            bottom: 5,
                            right: 6,
                            left: 6,
                            child: Center(
                              child: Text(
                                catDocSnap['categoryname'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
