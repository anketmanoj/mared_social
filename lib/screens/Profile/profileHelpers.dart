import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget headerProfile(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 200,
            width: 180,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: constantColors.transperant,
                    radius: 60,
                    backgroundImage: NetworkImage(snapshot.data!['userimage']),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    snapshot.data!['username'],
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        EvaIcons.email,
                        color: constantColors.greenColor,
                      ),
                      Text(
                        snapshot.data!['useremail'],
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: constantColors.darkColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 70,
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            "Followers",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: constantColors.darkColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 70,
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            "Following",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: constantColors.darkColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 70,
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            "Posts",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
