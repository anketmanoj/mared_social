import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late bool isAnon;

  late String userUid,
      googleUsername,
      googleUseremail,
      googleUserImage,
      googlePhoneNo;

  bool get getIsAnon => isAnon;
  String get getUserId => userUid;
  String get getgoogleUsername => googleUsername;
  String get getgoogleUseremail => googleUseremail;
  String get getgoogleUserImage => googleUserImage;
  String get getgooglePhoneNo => googlePhoneNo;

  Future loginIntoAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user!.uid;
    isAnon = false;
    print("logged in " + userUid);
    notifyListeners();
  }

  Future createAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user!.uid;
    isAnon = false;
    print(userUid);
    notifyListeners();
  }

  Future logOutViaEmail() {
    return firebaseAuth.signOut();
  }

  Future signInWithgoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User? user = userCredential.user;
    assert(user!.uid != null);

    userUid = user!.uid;
    isAnon = false;
    googleUseremail = user.email!;
    googleUsername = user.displayName!;
    googleUserImage = user.photoURL!;
    googlePhoneNo = user.phoneNumber ?? "No Number";
    print("Google sign in => ${userUid} || ${user.email}");

    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }

  Future signInAnon() async {
    try {
      var userCredential = await firebaseAuth.signInAnonymously();

      User? user = userCredential.user;
      userUid = user!.uid;
      isAnon = true;
      print("logged in " + userUid);
      notifyListeners();
    } catch (e) {
      print("FAILED === ${e.toString()}");
    }
  }
}
