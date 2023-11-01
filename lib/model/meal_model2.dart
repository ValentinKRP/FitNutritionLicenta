class MealModel2 {
  final String? id;
  final String name;
  final String carbohydrates;
  final String protein;
  final String fat;
  final String unit;
  final String serving;
  final String? date;
  final String when;
  final String calories;
  final String? directory;

  MealModel2({this.directory,  this.id, required this.calories, required this.when, required this.date,
    required this.name,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.unit,
    required this.serving,
  });
}
