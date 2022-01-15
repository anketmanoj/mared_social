import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/checkout/StripeCheckout.dart';
import 'package:mared_social/checkout/server_stub.dart';
import 'package:mared_social/checkout/stripe_checkout.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/promotePost/promotePostHelper.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PromotePost extends StatefulWidget {
  @override
  State<PromotePost> createState() => _PromotePostState();
}

class _PromotePostState extends State<PromotePost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Provider.of<PromotePostHelper>(context, listen: false)
          .appBar(context),
      body: Container(
        height: size.height,
        width: size.width,
        color: constantColors.blueGreyColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(
                  Provider.of<Authentication>(context, listen: false).getUserId)
              .collection("posts")
              .snapshots(),
          builder: (context, postSnaps) {
            if (postSnaps.connectionState == ConnectionState.waiting) {
              return LoadingWidget(constantColors: constantColors);
            } else {
              return SizedBox(
                height: size.height,
                width: size.width,
                child: ListView.builder(
                  itemCount: postSnaps.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot postData = postSnaps.data!.docs[index];
                    return ListTile(
                      trailing: ElevatedButton(
                        // onPressed: () => redirectToCheckout(context),
                        onPressed: () async {
                          // promotionBottomSheet(context, size, postData);
                          await makePayment();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          "Promote",
                        ),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: postData['imageslist'][index],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                            height: 50,
                            width: 50,
                            child:
                                LoadingWidget(constantColors: constantColors),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      title: Text(
                        postData['caption'],
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        postData['description'],
                        style: TextStyle(
                          color: constantColors.greenColor,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> promotionBottomSheet(
      BuildContext context, Size size, DocumentSnapshot<Object?> postData) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, innerState) {
          return Container(
            height: size.height * 0.7,
            width: size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 30,
                          color: constantColors.blueColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "By promoting your post, you're agreeing to the terms and conditions of Mared. Your promoted post will be active for 30 Days. No refunds are applicable with promoted posts and upon inspection from Mared, if the post is found to be harmful to the user experience, Mared can take the necessary action against the post.",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: size.height * 0.3,
                    width: size.width,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: postData['imageslist'][index],
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
                          itemCount: (postData['imageslist'] as List).length,
                          itemHeight: MediaQuery.of(context).size.height * 0.3,
                          itemWidth: MediaQuery.of(context).size.width,
                          layout: SwiperLayout.DEFAULT,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.date_range,
                          size: 30,
                          color: constantColors.blueColor,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "Post promoted till ${DateTime.now().add(Duration(days: 30)).toString().substring(0, 10)}",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await makePayment();
                            } catch (e) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: "Payment Failed",
                                text: e.toString(),
                              );
                            }
                          },
                          icon: const Icon(
                            FontAwesomeIcons.solidCreditCard,
                          ),
                          label: const Text("Promote Post"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  makePayment() async {
    final sessionID = await Server().createCheckout();
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StripeCheckoutPage(
          sessionId: sessionID,
        ),
      ),
    );

    if (result.toString() != "cancel") {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Congratulations! Your post is now featured on Mared! ⭐️",
          ),
        ),
      );
    }
  }
}
