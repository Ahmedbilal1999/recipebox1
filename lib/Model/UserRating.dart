import 'dart:convert';

class UserRating {
  int? recipeId;
  double recipeRating;
  UserRating({
    this.recipeId,
    this.recipeRating = 0.0,
  });

  UserRating copyWith({
    int? recipeId,
    double? recipeRating,
  }) {
    return UserRating(
      recipeId: recipeId ?? this.recipeId,
      recipeRating: recipeRating ?? this.recipeRating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeRating': recipeRating,
    };
  }

  factory UserRating.fromMap(Map<String, dynamic> map) {
    return UserRating(
      recipeId: map['recipeId']?.toInt(),
      recipeRating: map['recipeRating']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRating.fromJson(String source) =>
      UserRating.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserRating(recipeId: $recipeId, recipeRating: $recipeRating)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRating &&
        other.recipeId == recipeId &&
        other.recipeRating == recipeRating;
  }

  @override
  int get hashCode => recipeId.hashCode ^ recipeRating.hashCode;
}
