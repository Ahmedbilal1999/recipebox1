import 'dart:convert';

import 'package:recipebox/Constant/Helper.dart';
import 'package:recipebox/Model/recipeModal.dart';

class WeeklyModelGet {
  int? id;
  String? recipeName;
  int? recipeId;
  DateTime? startDate;
  DateTime? endDate;
  RecipeModel? recipe;
  DateTime? createTime;

  WeeklyModelGet(
      {this.id,
      this.recipeName,
      this.recipeId,
      this.startDate,
      this.endDate,
      this.recipe,
      this.createTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipeName': recipeName,
      'recipeId': recipeId,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate,
      // 'recipeVideo': recipeVideo?.toMap(),
    };
  }

  factory WeeklyModelGet.fromMap(Map<String, dynamic> map) {
    return WeeklyModelGet(
      id: map['id']?.toInt(),
      recipeName: map['recipeName'],
      recipeId: map['recipeId'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      recipe: map['recipe'] != null ? RecipeModel.fromMap(map['recipe']) : null,
      createTime: map['createTime'] != null
          ? Helper.DateUtcTOLocal(DateTime.parse(map['createTime']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeeklyModelGet.fromJson(String source) =>
      WeeklyModelGet.fromMap(json.decode(source));

  static List<WeeklyModelGet> allMealPlanModelFromJson(String str) =>
      List<WeeklyModelGet>.from(
          json.decode(str).map((x) => WeeklyModelGet.fromMap(x)));

  WeeklyModelGet copyWith(
      {int? id,
      String? recipeName,
      int? recipeId,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createTime}) {
    return WeeklyModelGet(
        id: id ?? this.id,
        recipeName: recipeName ?? this.recipeName,
        recipeId: recipeId ?? this.recipeId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        createTime: createTime ?? this.createTime);
  }
}
