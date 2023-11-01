// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracked_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackedFood _$TrackedFoodFromJson(Map<String, dynamic> json) => TrackedFood(
      json['name'] as String,
      json['carbohydrates'] as String,
      json['protein'] as String,
      json['fat'] as String,
      json['serving'] as String,
      json['unit'] as String,
    );

Map<String, dynamic> _$TrackedFoodToJson(TrackedFood instance) =>
    <String, dynamic>{
      'name': instance.name,
      'carbohydrates': instance.carbohydrates,
      'protein': instance.protein,
      'fat': instance.fat,
      'unit': instance.unit,
      'serving': instance.serving,
    };
