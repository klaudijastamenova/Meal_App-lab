import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/apiService.dart';
import '../services/favoriteService.dart';
import '../widgets/mealCard.dart';
import 'mealDetailsScreen.dart';

class MealsByCategory extends StatefulWidget {
  final String category;

  const MealsByCategory({super.key, required this.category});

  @override
  State<MealsByCategory> createState() => _MealsByCategoryState();
}

class _MealsByCategoryState extends State<MealsByCategory> {
  final _api = ApiService();
  final _favoritesService = FavoriteService();
  final TextEditingController _searchController = TextEditingController();

  List<Meal> _meals = [];
  List<Meal> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final list = await _api.loadMealsByCategory(widget.category);
    setState(() {
      _meals = list;
      _filtered = list;
      _loading = false;
    });
  }

  void filterMeals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = _meals;
      } else {
        _filtered = _meals
            .where((m) => m.mealName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleFavorite(String mealId) {
    _api.loadMealById(mealId).then((details) {
      final isAdded = _favoritesService.toggle(mealId, details);

      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAdded ? 'Added to favorites ❤️' : 'Removed from favorites'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search meals...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: filterMeals,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final meal = _filtered[index];
                final isFav = _favoritesService.isFavorite(meal.mealID);

                return MealCard(
                  meal: meal,
                  isFavorite: isFav,
                  onFavoriteToggle: () => _toggleFavorite(meal.mealID),
                  onTap: () async {
                    final details = await _api.loadMealById(meal.mealID);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailsScreen(meal: details),
                      ),
                    ).then((_) => setState(() {}));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}