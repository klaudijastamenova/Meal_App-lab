class MealDetail{

  final String id;
  final String name;
  final String category;
  final String area;
  final String thumbnail;
  final String instructions;
  final String? youtubeLink;
  final Map<String, String> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.thumbnail,
    required this.instructions,
    required this.youtubeLink,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> j) {
    final ing = <String, String>{};
    for (int i = 1; i <= 20; i++) {
      final ingredient = j['strIngredient$i'] as String?;
      final measure = j['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ing[ingredient.trim()] = (measure ?? '').trim();
      }
    }
    return MealDetail(
      id: j['idMeal'] as String,
      name: j['strMeal'] as String,
      category: j['strCategory'] as String? ?? '',
      area: j['strArea'] as String? ?? '',
      thumbnail: j['strMealThumb'] as String? ?? '',
      instructions: j['strInstructions'] as String? ?? '',
      youtubeLink: j['strYoutube'] as String?,
      ingredients: ing,
    );
  }


}