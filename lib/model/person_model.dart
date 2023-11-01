class PersonModel {
  final String name;
  final bool metric;
  final String sex;
  final double weight;
  final double height;
  final int age;
  final double activityLevel;
  final String goal;
  Map<String, dynamic> personalNutrients;

  PersonModel(
    {required this.name,
    required this.sex,
    required this.metric,
    required this.height,
    required this.weight,
    required this.age,
    required this.activityLevel,
    required this.goal,
    required this.personalNutrients,}
  );
}
