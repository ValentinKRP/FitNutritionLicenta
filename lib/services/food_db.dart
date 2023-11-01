import 'dart:convert';
import 'package:fitnutrition/model/meal_api_model.dart';
import 'package:fitnutrition/model/meal_model2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodDB extends ChangeNotifier {
  var url =
      "https://api.nal.usda.gov/fdc/v1/foods/list?api_key=bWaUD0HHUiz7J832kxMrDh6figb1BU2QsWroYX9H";
  List<MealModel2> searchList = [];

  void clearList() {
    searchList.clear();

    notifyListeners();
  }

  Future<void> foodQueryForId(
      String food, String when, String currentDate) async {
    List<MealModel2> mealModelNew = [];

    String urln = url + '&query=' + food + "&pageSize=10";
    debugPrint(urln);

    var response = await http.get(Uri.parse(urln));
    if (response.statusCode == 200) {
      List<dynamic> mealListCall = json.decode(response.body);
      for (dynamic meal in mealListCall) {
        MealApiModel convert = MealApiModel.fromJson(meal);

        if (convert.foodNutrients != null) {
          var foodNutrientsList = convert.foodNutrients;
          String p = "0.0", c = "0.0", f = "0.0", u = "g";
          for (var foodNutrientnew in foodNutrientsList!) {
            if (foodNutrientnew.name == "Protein") {
              p = foodNutrientnew.amount.toString();
            }
            if (foodNutrientnew.name == "Total lipid (fat)") {
              f = foodNutrientnew.amount.toString();
            }
            if (foodNutrientnew.name == "Carbohydrate, by difference") {
              c = foodNutrientnew.amount.toString();
            }
            if (foodNutrientnew.unitName == "G") {
              u = 'g';
            }
          }

          double cal =
              (double.parse(c) + double.parse(p)) * 4.0 + double.parse(f) * 9.0;
          mealModelNew.add(MealModel2(
              calories: cal.toString(),
              when: when,
              date: currentDate,
              name: convert.description ?? "",
              carbohydrates: c,
              protein: p,
              fat: f,
              unit: u,
              serving: "100"));
        }
      }
    } else {
      throw Exception("Please try again");
    }
    searchList = mealModelNew;
    mealModelNew = [];
    notifyListeners();
  }
}
