// class RecipeDetailsModel {
//   final String id;
//   final String name;
//   final String category;
//   final String area;
//   final String instructions;
//   final String image;
//   final String youtube;

//   final List<String> images;

//   final List<String> ingredients;
//   final List<String> measures;

//   RecipeDetailsModel({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.area,
//     required this.instructions,
//     required this.image,
//     required this.youtube,
//     required this.images,
//     required this.ingredients,
//     required this.measures,
//   });

//   factory RecipeDetailsModel.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     final List<String> ingredients = [];
//     final List<String> measures = [];

//     for (int i = 1; i <= 20; i++) {
//       final String ingredient =
//           json['strIngredient$i']?.toString().trim() ?? '';

//       final String measure =
//           json['strMeasure$i']?.toString().trim() ?? '';

//       if (ingredient.isNotEmpty) {
//         ingredients.add(ingredient);
//         measures.add(measure);
//       }
//     }

//     final String mainImage =
//         json['strMealThumb']?.toString().trim() ?? '';

//     // TheMealDB currently provides one main recipe image.
//     // We keep it inside a list so the UI can support
//     // multiple images later.
//     final List<String> images = [];

//     if (mainImage.isNotEmpty) {
//       images.add(mainImage);
//     }

//     return RecipeDetailsModel(
//       id: json['idMeal']?.toString() ?? '',
//       name: json['strMeal']?.toString() ?? '',
//       category: json['strCategory']?.toString() ?? '',
//       area: json['strArea']?.toString() ?? '',
//       instructions:
//           json['strInstructions']?.toString() ?? '',
//       image: mainImage,
//       youtube: json['strYoutube']?.toString() ?? '',
//       images: images,
//       ingredients: ingredients,
//       measures: measures,
//     );
//   }
// }
class RecipeDetailsModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String image;
  final String youtube;
  final List<String> images;
  final List<String> ingredients;
  final List<String> measures;

  RecipeDetailsModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
    required this.youtube,
    required this.images,
    required this.ingredients,
    required this.measures,
  });

  factory RecipeDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<String> ingredients = [];
    final List<String> measures = [];

    // =========================================================
    // INGREDIENTS + MEASURES
    // =========================================================

    for (int i = 1; i <= 20; i++) {
      final String ingredient =
          json['strIngredient$i']?.toString().trim() ?? '';

      final String measure =
          json['strMeasure$i']?.toString().trim() ?? '';

      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure);
      }
    }

    // =========================================================
    // MAIN RECIPE IMAGE
    // =========================================================

    final String mainImage =
        json['strMealThumb']?.toString().trim() ?? '';

    // =========================================================
    // API IMAGES
    //
    // TheMealDB currently gives us one recipe image:
    // strMealThumb
    //
    // So we only add the image if it actually exists.
    // No duplicate/fake images are created.
    // =========================================================

    final List<String> images = [];

    if (mainImage.isNotEmpty) {
      images.add(mainImage);
    }

    // =========================================================
    // RETURN MODEL
    // =========================================================

    return RecipeDetailsModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '',
      area: json['strArea']?.toString() ?? '',
      instructions:
          json['strInstructions']?.toString() ?? '',
      image: mainImage,
      youtube: json['strYoutube']?.toString() ?? '',
      images: images,
      ingredients: ingredients,
      measures: measures,
    );
  }
}