import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnutrition/model/meal_model2.dart';
import 'package:fitnutrition/model/person_model.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDb extends ChangeNotifier {
  late PersonModel person;
  List<MealModel2> mealList = [];
  List<MealModel2> mealListUser = [];

  // Future createNewUser(String name, bool metric, String sex, double height,
  //     double weight, int age, double activityLevel, String goal) async {
  //   final uid = FirebaseAuth.instance.currentUser!.uid;

  //   return await FirebaseFirestore.instance.collection('Tracker').doc(uid).set(
  //     {
  //       'name': name,
  //       'metric': metric,
  //       'sex': sex,
  //       'height': height,
  //       'weight': weight,
  //       'age': age,
  //       'activityLevel': activityLevel,
  //       'goal': goal,
  //       'personalNutrients': _generateNutrients(
  //           metric, sex, height, weight, age, activityLevel, goal)
  //     },
  //     SetOptions(merge: true),
  //   );
  // }

  void getPerson() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('Tracker')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        person = PersonModel(
            name: documentSnapshot["name"],
            sex: documentSnapshot["sex"],
            metric: documentSnapshot["metric"],
            height: documentSnapshot["height"],
            weight: documentSnapshot["weight"],
            age: documentSnapshot["age"],
            activityLevel: documentSnapshot["activityLevel"],
            goal: documentSnapshot["goal"],
            personalNutrients:
                documentSnapshot["personalNutrients"] as Map<String, dynamic>);
      }
    });
    notifyListeners();
  }

  void getMeals() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    mealList = [];
    await FirebaseFirestore.instance
        .collection('Tracker/$uid/meals')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        mealList.add(
          MealModel2(
            carbohydrates: doc["carbohydrates"],
            fat: doc["fat"].toString(),
            name: doc["name"],
            protein: doc["protein"].toString(),
            serving: doc["serving"].toString(),
            unit: doc["unit"].toString(),
            date: doc["date"],
            calories: doc["calories"].toString(),
            when: doc["when"],
            id: doc.id,
          ),
        );
      }
    });
    notifyListeners();
  }

  void getMealsUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    mealListUser = [];
    await FirebaseFirestore.instance
        .collection('Tracker/$uid/meals_list')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        mealListUser.add(
          MealModel2(
            carbohydrates: doc["carbohydrates"].toString(),
            fat: doc["fat"].toString(),
            name: doc["name"],
            protein: doc["protein"].toString(),
            serving: doc["serving"].toString(),
            unit: doc["unit"],
            date: doc["date"],
            calories: doc["calories"].toString(),
            id: doc.id,
            when: doc["when"],
          ),
        );
      }
    });
    notifyListeners();
  }

  Future<void> createNewMeals(MealModel2 foods) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('Tracker/$uid/meals').add(
      {
        "carbohydrates": foods.carbohydrates,
        "fat": foods.fat,
        "name": foods.name,
        "protein": foods.protein,
        "serving": foods.serving,
        "unit": foods.unit,
        "date": foods.date,
        "calories": foods.calories,
        "when": foods.when,
      },
    );
    getMeals();
  }

  Future<void> createNewUserMeal(MealModel2 foods) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('Tracker/$uid/meals_list').add(
      {
        "carbohydrates": foods.carbohydrates,
        "fat": foods.fat,
        "name": foods.name,
        "protein": foods.protein,
        "serving": foods.serving,
        "unit": foods.unit,
        "date": foods.date,
        "calories": foods.calories,
        "when": foods.when,
      },
    );
    getMealsUser();
  }

  Future<void> setNewGoals({
    required double weight,
    required double activityLevel,
    required String goal,
    required PersonModel personModel,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('Tracker').doc(uid).set(
      {
        'weight': weight,
        'activityLevel': activityLevel,
        'goal': goal,
        'personalNutrients': _generateNutrients(
            personModel.metric,
            personModel.sex,
            personModel.height,
            weight,
            personModel.age,
            activityLevel,
            goal)
      },
      SetOptions(merge: true),
    );
    getPerson();
  }

  Future<void> deleteMeal(String? docId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference mealDocument =
        FirebaseFirestore.instance.collection('Tracker/$uid/meals');
    await mealDocument
        .doc(docId)
        .delete()
        .then((value) => debugPrint("User Deleted"))
        .catchError((error) => debugPrint("Failed to delete user: $error"));
    getMeals();
  }

  Future<void> deleteUserMeal(String? docId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference mealDocument =
        FirebaseFirestore.instance.collection('Tracker/$uid/meals_list');
    await mealDocument
        .doc(docId)
        .delete()
        .then((value) => debugPrint("User Deleted"))
        .catchError((error) => debugPrint("Failed to delete user: $error"));
    getMealsUser();
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
