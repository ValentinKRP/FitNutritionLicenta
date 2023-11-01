import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitnutrition/services/user_creator.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanged => _firebaseAuth.authStateChanges();

  Future<void> signInAnon() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String name,
      required String sex,
      required double height,
      required double weight,
      required int age,
      required double activityLevel,
      required String goal}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    UserCreator databaseService = UserCreator();
    await databaseService.createNewUser(
        name, true, sex, height, weight, age, activityLevel, goal);
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
