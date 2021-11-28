import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late String userUid, googleUsername, googleUseremail, googleUserImage;
  String get getUserId => userUid;
  String get getgoogleUsername => googleUsername;
  String get getgoogleUseremail => googleUseremail;
  String get getgoogleUserImage => googleUserImage;

  Future loginIntoAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user!.uid;
    print("logged in " + userUid);
    notifyListeners();
  }

  Future createAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    userUid = user!.uid;
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
    googleUseremail = user.email!;
    googleUsername = user.displayName!;
    googleUserImage = user.photoURL!;
    print("Google sign in => ${userUid} || ${user.email}");

    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
