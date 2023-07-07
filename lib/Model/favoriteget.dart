import 'dart:convert';

import 'package:recipebox/Constant/Helper.dart';
import 'package:recipebox/Model/recipeModal.dart';

import 'RecipeVideoModel.dart';

class FavoriteRecipeModel {
  int? id;
  String? name;
  String? description;
  String? fileUrl;
  DateTime? date;
  DateTime? createTime;
  int? recipeVideoId;
  VideoRecipeModel? recipeVideo;
  int? recipeId;
  RecipeModel? recipe;
  FavoriteRecipeModel(
      {this.id,
      this.name,
      this.description,
      this.fileUrl,
      this.date,
      this.createTime,
      this.recipeVideoId,
      this.recipeVideo,
      this.recipeId,
      this.recipe});

  FavoriteRecipeModel copyWith(
      {int? id,
      String? name,
      String? description,
      String? fileUrl,
      DateTime? date,
      DateTime? createTime,
      int? recipeVideoId,
      VideoRecipeModel? recipeVideo,
      int? recipeId,
      RecipeModel? recipe}) {
    return FavoriteRecipeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        fileUrl: fileUrl ?? this.fileUrl,
        date: date ?? this.date,
        recipeVideoId: recipeVideoId ?? this.recipeVideoId,
        recipeVideo: this.recipeVideo ?? this.recipeVideo,
        recipeId: this.recipeId ?? this.recipeId,
        recipe: this.recipe ?? this.recipe);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fileUrl': fileUrl,
      'date': date?.millisecondsSinceEpoch,
      'recipeVideoId': recipeVideoId
    };
  }

  factory FavoriteRecipeModel.fromMap(Map<String, dynamic> map) {
    return FavoriteRecipeModel(
      id: map['id']?.toInt(),
      name: map['name'],
      description: map['description'],
      fileUrl: map['fileUrl'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      createTime: map['createTime'] != null
          ? Helper.DateUtcTOLocal(DateTime.parse(map['createTime']))
          : null,
      recipeVideoId: map['recipeVideoId']?.toInt(),
      recipeVideo: map['recipeVideo'] != null
          ? VideoRecipeModel.fromMap(map['recipeVideo'])
          : null,
      recipeId: map['recipeId']?.toInt(),
      recipe: map['recipe'] != null ? RecipeModel.fromMap(map['recipe']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteRecipeModel.fromJson(String source) =>
      FavoriteRecipeModel.fromMap(json.decode(source));

  static List<FavoriteRecipeModel> allMealPlanModelFromJson(String str) =>
      List<FavoriteRecipeModel>.from(
          json.decode(str).map((x) => FavoriteRecipeModel.fromMap(x)));
}
