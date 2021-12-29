import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  final String userUid;
  AltProfile({Key? key, required this.userUid}) : super(key: key);

  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: Provider.of<AltProfileHelper>(context, listen: false)
            .appBar(context),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: constantColors.blueGreyColor,
            ),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(userUid)
                  .snapshots(),
              builder: (context, userDocSnap) {
                if (userDocSnap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Provider.of<AltProfileHelper>(context, listen: false)
                          .headerProfile(
                              context: context,
                              userDocSnap: userDocSnap,
                              userUid: userUid),
                      Provider.of<AltProfileHelper>(context, listen: false)
                          .divider(),
                      Provider.of<AltProfileHelper>(context, listen: false)
                          .middleProfile(
                        context: context,
                        snapshot: userDocSnap,
                      ),
                      Provider.of<AltProfileHelper>(context, listen: false)
                          .footerProfile(
                        context: context,
                        userUid: userUid,
                        snapshot: userDocSnap,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
