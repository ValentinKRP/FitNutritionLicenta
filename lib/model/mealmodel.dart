import './tracked_food.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mealmodel.g.dart';

@JsonSerializable()
class MealModel {
  final String mealName;
  List<TrackedFood> foods;

  MealModel(
    this.mealName,
    this.foods,
  );

  double calculateCarbs() {
    double trackedCarbs = 0.0;
    for (TrackedFood food in foods) {
      trackedCarbs += food.toMap().containsKey('carbohydrates')
          ? double.parse(food.toMap()['carbohydrates'])
          : 0;
    }
    return trackedCarbs;
  }

  double calculateProtein() {
    double trackedProtein = 0.0;
    for (TrackedFood food in foods) {
      trackedProtein += food.toMap().containsKey('protein')
          ? double.parse(food.toMap()['protein'])
          : 0;
    }
    return trackedProtein;
  }

  double calculateFat() {
    double trackedFat = 0.0;
    for (TrackedFood food in foods) {
      trackedFat += food.toMap().containsKey('fat')
          ? double.parse(food.toMap()['fat'])
          : 0;
    }
    return trackedFat;
  }

  double calculateCalories() {
    return ((calculateCarbs() + calculateProtein()) * 4) + (calculateFat() * 9);
  }

  void deleteFoodItem(String foodName) {
    foods.where((element) => element.name != foodName);
  }

  void addFoodItem(TrackedFood food) {
    foods.add(food);
  }

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);

  Map<dynamic, dynamic> toJson() => _$MealModelToJson(this);
}
