import 'dart:convert';

class FavoriteRecipeModel {
  final String id;
  final String name;
  final String image;

  FavoriteRecipeModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory FavoriteRecipeModel.fromMap(Map<String, dynamic> map) {
    return FavoriteRecipeModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  // Local Storage serialization (GetStorage support)
  String toJson() => json.encode(toMap());

  factory FavoriteRecipeModel.fromJson(String source) =>
      FavoriteRecipeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}