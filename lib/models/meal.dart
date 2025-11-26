class Meal {
  final String mealID;
  final String mealName;
  final String mealThumb;

  Meal({
    required this.mealID,
    required this.mealName,
    required this.mealThumb,
  });

  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
    mealID: j['idMeal'] as String,
    mealName: j['strMeal'] as String,
    mealThumb: j['strMealThumb'] as String,
  );
}