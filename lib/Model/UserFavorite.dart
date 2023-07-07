import 'dart:convert';

class UserFavorite {
  bool isFavorite;
  int? recipeId;
  UserFavorite({
    this.isFavorite = false,
    this.recipeId,
  });
  Map<String, dynamic> toMap() {
    return {
      'isFavorite': isFavorite,
      'recipeId': recipeId,
    };
  }

  factory UserFavorite.fromMap(Map<String, dynamic> map) {
    return UserFavorite(
      isFavorite: map['isFavorite'],
      recipeId: map['recipeId']?.toInt(),
    );
  }
  factory UserFavorite.fromJson(String source) =>
      UserFavorite.fromMap(json.decode(source));
}
