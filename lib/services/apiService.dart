import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/mealDetail.dart';

class ApiService {
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> loadCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categoriesJson = data['categories'];
      return categoriesJson.map((c) => Category.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> loadMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'];
      return mealsJson.map((m) => Meal.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load meals for category $category');
    }
  }

  Future<MealDetail> loadMealById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final mealJson = data['meals'][0];
      return MealDetail.fromJson(mealJson);
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  Future<MealDetail> loadRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final mealJson = data['meals'][0];
      return MealDetail.fromJson(mealJson);
    } else {
      throw Exception('Failed to load random meal');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List? mealsJson = data['meals'];
      if (mealsJson != null) {
        return mealsJson.map((m) => Meal.fromJson(m)).toList();
      }
      return [];
    } else {
      throw Exception('Failed to search meals');
    }
  }
}
