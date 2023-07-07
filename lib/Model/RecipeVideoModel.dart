import 'dart:convert';

import 'package:recipebox/Constant/Helper.dart';

class VideoRecipeModel {
  int? id;
  String? name;
  String? description;
  String? fileUrl;
  DateTime? date;
  DateTime? createTime;
  VideoRecipeModel(
      {this.id,
      this.name,
      this.description,
      this.fileUrl,
      this.date,
      this.createTime});

  VideoRecipeModel copyWith(
      {int? id,
      String? name,
      String? description,
      String? fileUrl,
      DateTime? date,
      DateTime? createTime}) {
    return VideoRecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fileUrl': fileUrl,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory VideoRecipeModel.fromMap(Map<String, dynamic> map) {
    return VideoRecipeModel(
      id: map['id']?.toInt(),
      name: map['name'],
      description: map['description'],
      fileUrl: map['fileUrl'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      createTime: map['createTime'] != null
          ? Helper.DateUtcTOLocal(DateTime.parse(map['createTime']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoRecipeModel.fromJson(String source) =>
      VideoRecipeModel.fromMap(json.decode(source));

  static List<VideoRecipeModel> allMealPlanModelFromJson(String str) =>
      List<VideoRecipeModel>.from(
          json.decode(str).map((x) => VideoRecipeModel.fromMap(x)));
}
