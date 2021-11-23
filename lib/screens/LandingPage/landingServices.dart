import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingService with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Select Profile Picture",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: constantColors.transperant,
                  backgroundImage: FileImage(
                    Provider.of<LandingUtils>(context, listen: false)
                        .userAvatar,
                  ),
                ),
                Row(
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
                        Provider.of<LandingUtils>(context, listen: false)
                            .pickUserAvatar(
                          context,
                          ImageSource.gallery,
                        );
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
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .uploadUserAvatar(context)
                            .whenComplete(() {
                          signUpSheet(context);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
  }

  Widget passwordlessSignIn(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  return ListTile(
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.trashAlt,
                        color: constantColors.redColor,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: constantColors.transperant,
                      backgroundImage:
                          NetworkImage(documentSnapshot['userimage']),
                    ),
                    subtitle: Text(
                      documentSnapshot['useremail'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor,
                        fontSize: 12,
                      ),
                    ),
                    title: Text(
                      documentSnapshot['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor,
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ));
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () async {
                          if (userEmailController.text.isNotEmpty &&
                              userPasswordController.text.isNotEmpty) {
                            try {
                              await Provider.of<Authentication>(context,
                                      listen: false)
                                  .loginIntoAccount(userEmailController.text,
                                      userPasswordController.text);

                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop),
                              );
                            } catch (e) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: "Sign In Failed",
                                text: e.toString(),
                              );
                            }
                          } else {
                            warningText(context, "Fill all details");
                          }
                        }),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )),
            ),
          );
        });
  }

  signUpSheet(BuildContext context) {
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
                CircleAvatar(
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .getUserAvatar),
                  backgroundColor: constantColors.redColor,
                  radius: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.whiteColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userEmailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.whiteColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userPasswordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.whiteColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FloatingActionButton(
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () async {
                        if (userEmailController.text.isNotEmpty &&
                            userPasswordController.text.isNotEmpty) {
                          try {
                            await Provider.of<Authentication>(context,
                                    listen: false)
                                .createAccount(userEmailController.text,
                                    userPasswordController.text);

                            print("creating collection");

                            await Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .createUserCollection(context, {
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                              'useremail': userEmailController.text,
                              'username': userNameController.text,
                              'userimage': Provider.of<LandingUtils>(context,
                                      listen: false)
                                  .getUserAvatarUrl,
                            });

                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: HomePage(),
                                  type: PageTransitionType.bottomToTop),
                            );
                          } catch (e) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: "Sign In Failed",
                              text: e.toString(),
                            );
                          }
                        } else {
                          warningText(context, "Fill all details");
                        }
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(15),
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(warning),
          ),
        );
      },
    );
  }
}
