import 'dart:convert';

import 'package:recipebox/Constant/Helper.dart';
import 'package:recipebox/Model/RecipeVideoModel.dart';
import 'package:recipebox/Model/UserFavorite.dart';
import 'package:recipebox/Model/UserRating.dart';

class RecipeModel {
  int? id;
  String? title;
  String? discription;
  DateTime? date;
  int? recipeVideoId;
  VideoRecipeModel? recipeVideo;
  String? fileUrl;
  DateTime? createTime;
  UserFavorite? favoriteUser;
  UserRating? ratingUser;
  RecipeModel(
      {this.id,
      this.title,
      this.discription,
      this.date,
      this.recipeVideoId,
      this.recipeVideo,
      this.fileUrl,
      this.createTime,
      this.favoriteUser,
      this.ratingUser});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'discription': discription,
      'date': date?.toIso8601String(),
      'recipeVideoId': recipeVideoId,
      'fileUrl': fileUrl,

      // 'recipeVideo': recipeVideo?.toMap(),
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id']?.toInt(),
      title: map['title'],
      fileUrl: map['fileUrl'],
      discription: map['discription'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      recipeVideoId: map['recipeVideoId']?.toInt(),
      recipeVideo: map['recipeVideo'] != null
          ? VideoRecipeModel.fromMap(map['recipeVideo'])
          : null,
      favoriteUser: map['favoriteUser'] != null
          ? UserFavorite.fromMap(map['favoriteUser'])
          : null,
      ratingUser: map['ratingUser'] != null
          ? UserRating.fromMap(map['ratingUser'])
          : null,
      createTime: map['createTime'] != null
          ? Helper.DateUtcTOLocal(DateTime.parse(map['createTime']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source));

  static List<RecipeModel> allMealPlanModelFromJson(String str) =>
      List<RecipeModel>.from(
          json.decode(str).map((x) => RecipeModel.fromMap(x)));

  RecipeModel copyWith(
      {int? id,
      String? title,
      String? discription,
      DateTime? date,
      int? recipeVideoId,
      VideoRecipeModel? recipeVideo,
      DateTime? createTime}) {
    return RecipeModel(
        id: id ?? this.id,
        title: title ?? this.title,
        discription: discription ?? this.discription,
        date: date ?? this.date,
        recipeVideoId: recipeVideoId ?? this.recipeVideoId,
        recipeVideo: recipeVideo ?? this.recipeVideo,
        createTime: createTime ?? this.createTime);
  }
}
