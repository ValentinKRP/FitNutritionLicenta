// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tracker _$TrackerFromJson(Map<String, dynamic> json) => Tracker(
      json['name'] as String,
      json['sex'] as String,
      json['metric'] as bool,
      (json['height'] as num).toDouble(),
      (json['weight'] as num).toDouble(),
      json['age'] as int,
      (json['activityLevel'] as num).toDouble(),
      json['goal'] as String,
      (json['personalNutrients'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      (json['meals'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => TrackedFood.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      (json['directory'] as List<dynamic>)
          .map((e) => TrackedFood.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrackerToJson(Tracker instance) => <String, dynamic>{
      'name': instance.name,
      'metric': instance.metric,
      'sex': instance.sex,
      'weight': instance.weight,
      'height': instance.height,
      'age': instance.age,
      'activityLevel': instance.activityLevel,
      'goal': instance.goal,
      'personalNutrients': instance.personalNutrients,
      'meals': instance.meals,
      'directory': instance.directory,
    };
