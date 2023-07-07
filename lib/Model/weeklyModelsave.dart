import 'dart:convert';

class WeeklyModelSave {
  int? id;
  int? recipeId;
  DateTime? startDate;

  WeeklyModelSave({
    this.id,
    this.recipeId,
    this.startDate,
  });

  WeeklyModelSave copyWith({
    int? id,
    int? recipeId,
    DateTime? startDate,
  }) {
    return WeeklyModelSave(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      startDate: startDate ?? this.startDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipeId': recipeId,
      'startDate': startDate,
    };
  }

  factory WeeklyModelSave.fromMap(Map<String, dynamic> map) {
    return WeeklyModelSave(
      id: map['id']?.toInt(),
      recipeId: map['recipeId'],
      startDate: map['startDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WeeklyModelSave.fromJson(String source) =>
      WeeklyModelSave.fromMap(json.decode(source));

  static List<WeeklyModelSave> allMealPlanModelFromJson(String str) =>
      List<WeeklyModelSave>.from(
          json.decode(str).map((x) => WeeklyModelSave.fromMap(x)));
}
