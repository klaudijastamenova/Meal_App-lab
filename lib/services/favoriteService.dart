import '../models/mealDetail.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  final List<String> _favoriteIds = [];
  final List<MealDetail> _favoriteMeals = [];

  bool isFavorite(String id) => _favoriteIds.contains(id);

  bool toggle(String id, MealDetail meal) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
      _favoriteMeals.removeWhere((m) => m.id == id);
      return false;
    } else {
      _favoriteIds.add(id);
      _favoriteMeals.add(meal);
      return true;
    }
  }
  List<MealDetail> getFavorites() => List.from(_favoriteMeals);
  int get count => _favoriteIds.length;

  void clearAll() {
    _favoriteIds.clear();
    _favoriteMeals.clear();
  }
}