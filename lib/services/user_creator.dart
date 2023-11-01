import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserCreator {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  final CollectionReference trackerCollection =
      FirebaseFirestore.instance.collection('Tracker');

  Future createNewUser(String name, bool metric, String sex, double height,
      double weight, int age, double activityLevel, String goal) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return await trackerCollection.doc(uid).set(
      {
        'name': name,
        'metric': metric,
        'sex': sex,
        'height': height,
        'weight': weight,
        'age': age,
        'activityLevel': activityLevel,
        'goal': goal,
        'personalNutrients': _generateNutrients(
            metric, sex, height, weight, age, activityLevel, goal)
      },
      SetOptions(merge: true),
    );
  }

  _generateNutrients(bool metric, String sex, double height, double weight,
      int age, double activityLevel, String goal) {
    double calories;
    double carbohydrates;
    double protein;
    double fat;
    if (sex == "F") {
      calories = activityLevel *
          ((9.247 * weight) + (3.098 * height) - (4.330 * age) + 447.593);

      if (goal == "lose") {
        calories *= 0.75;
        carbohydrates = calories * 0.35 / 4;
        protein = calories * 0.35 / 4;
        fat = calories * 0.3 / 9;
      } else if (goal == "gain") {
        calories *= 1.25;
        carbohydrates = calories * 0.45 / 4;
        protein = calories * 0.25 / 4;
        fat = calories * 0.3 / 9;
      } else {
        carbohydrates = calories * 0.4 / 4;
        protein = calories * 0.25 / 4;
        fat = calories * 0.35 / 9;
      }
    } else {
      calories = activityLevel *
          ((13.397 * weight) + (4.799 * height) - (5.667 * age) + 88.362);

      if (goal == "lose") {
        calories *= 0.8;
        carbohydrates = calories * 0.35 / 4;
        protein = calories * 0.35 / 4;
        fat = calories * 0.3 / 9;
      } else if (goal == "gain") {
        calories *= 1.35;
        carbohydrates = calories * 0.45 / 4;
        protein = calories * 0.25 / 4;
        fat = calories * 0.3 / 9;
      } else {
        carbohydrates = calories * 0.4 / 4;
        protein = calories * 0.25 / 4;
        fat = calories * 0.35 / 9;
      }
    }

    return {
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      // 'calcium': sex == "F" ? 1200 : 1000,
      // 'iron': sex == "F" ? age <= 50 ? 18 : 8 : age <= 18 ? 11 : 8,
      // 'potassium': 4600,
      // 'sodium': 2300,
      // 'fiber': sex == "F" ? 25 : 40,
      // 'vitaminA': sex == "F" ? 700 : 900,
      // 'vitaminC': sex == "F" ? 75 : 90,
    };
  }
}
