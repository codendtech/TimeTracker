import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.uid});
  String uid;
}

abstract class AuthBase {
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> registerUserWithEmail(String email, String password);
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInAnonimously();
  Future<void> signOut();
}

class Auth implements AuthBase {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FacebookLogin facebookLogin = FacebookLogin();

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonimously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_AUTH_TOKEN',
            message: 'Google sign in authentication token is missing.');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Google sign in aborted by user.');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final result =
        await facebookLogin.logInWithReadPermissions(['public_profile']);
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth
          .signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      ));
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Google sign in aborted by user.');
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> registerUserWithEmail(String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
