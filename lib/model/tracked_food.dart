// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:json_annotation/json_annotation.dart';

part 'tracked_food.g.dart';

@JsonSerializable()
class TrackedFood {
  final String name;

  final String carbohydrates;
  final String protein;
  final String fat;

  String unit;
  String serving;

  TrackedFood(this.name, this.carbohydrates, this.protein, this.fat,
      this.serving, this.unit);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      "serving": serving,
      "unit": unit,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'fat': fat,
    };
  }

  String calculateCalories() {
    return ((((double.parse(carbohydrates) + double.parse(protein)) * 4) +
            (double.parse(fat) * 9)))
        .round()
        .toString();
  }

  factory TrackedFood.fromFDCJsonfoodNutrients(Map<String, dynamic> json) {
    var carbs;
    var protein;
    var fat;

    List foodNutrients = json['foodNutrients'];
    int count = 3;
    for (int i = 0; i < foodNutrients.length; i++) {
      if (count > 0) {
        switch (foodNutrients[i]['name']) {
          case "Total lipid (fat)":
            fat = foodNutrients[i]['amount'];
            count = count - 1;
            break;
          case 'Carbohydrate, by difference':
            carbs = foodNutrients[i]['amount'];
            count = count - 1;
            break;
          case 'Protein':
            protein = foodNutrients[i]['amount'];
            count = count - 1;
            break;
        }
      } else {
        break;
      }
    }

    return TrackedFood(
        json['description'].toString() +
            "," +
            (json.containsKey('brandOwner') ? '' : json['brandOwner']),
        '1',
        'serving',
        carbs ?? 0,
        protein ?? 0,
        fat ?? 0);
  }

  factory TrackedFood.fromFDCJsonLabelNutrients(Map<String, dynamic> json) {
    return TrackedFood(
        json['name'].toString() + json['brandedFoodCategory'].toString(),
        json['servingSize'],
        json['servingSizeUnit'],
        json['labelNutrients']['carbohydrates']['value'],
        json['labelNutrients']['protein']['value'],
        json['labelNutrients']['fat']['value']);
  }

  getServing(TrackedFood food, Map<String, dynamic> json) {
    food.serving = json['foodPortions'][0]['gramWeight'];
    food.unit = 'g';
  }

  factory TrackedFood.fromJson(Map<String, dynamic> json) =>
      _$TrackedFoodFromJson(json);

  Map<dynamic, dynamic> toJson() => _$TrackedFoodToJson(this);
}
