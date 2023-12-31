import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('company');

  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      dev.log(e.toString());

      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);

      myUser = myUser.copyWith(userId: user.user!.uid);

      return myUser;
    } catch (e) {
      dev.log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.companyName)
          .collection('users')
          .doc(myUser.email)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      dev.log(e.toString());
    }
  }
}
