import './mealmodel.dart';
import 'package:json_annotation/json_annotation.dart';
import './tracked_food.dart';


part 'tracker.g.dart';

@JsonSerializable()
class Tracker {
  final String name;
  final bool metric;
  final String sex;
  final double weight;
  final double height;
  final int age;
  final double activityLevel;
  final String goal;
  Map<String, double> personalNutrients;
  Map<String, List<TrackedFood>> meals;
  List<TrackedFood> directory;

  Tracker(
      this.name,
      this.sex,
      this.metric,
      this.height,
      this.weight,
      this.age,
      this.activityLevel,
      this.goal,
      this.personalNutrients,
      this.meals,
      this.directory);

  List<MealModel> get mealsList =>
      meals.entries.map((e) => MealModel(e.key, e.value)).toList();

  factory Tracker.fromJson(Map<String, dynamic> json) =>
      _$TrackerFromJson(json);

  Map<dynamic, dynamic> toJson() => _$TrackerToJson(this);
}
