import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/apiService.dart';
import '../services/notificationService.dart';
import '../widgets/categoryCard.dart';
import 'mealsByCategory.dart';
import 'mealDetailsScreen.dart';
import 'favoriteScreen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _api = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Category> _categories = [];
  List<Category> _filtered = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();

    NotificationService.initNotifications();
    sendDailyRecipeNotification();
  }

  Future<void> loadCategories() async {
    final list = await _api.loadCategories();
    setState(() {
      _categories = list;
      _filtered = list;
      _loading = false;
    });
  }

  void filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = _categories;
      } else {
        _filtered = _categories
            .where((c) =>
            c.categoryName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> sendDailyRecipeNotification() async {
    try {
      final meal = await _api.loadRandomMeal();
      await NotificationService.showDailyRecipeNotification(
        "Recipe of the Day",
        meal.name,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading daily recipe: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: "Favorites",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoriteScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: "Random Recipe",
            onPressed: () async {
              try {
                final meal = await _api.loadRandomMeal();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MealDetailsScreen(meal: meal),
                  ),
                );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading random meal: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: filterCategories,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final category = _filtered[index];
                return CategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealsByCategory(
                            category: category.categoryName),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.notifications),
        tooltip: "Test daily notification",
        onPressed: () {
          sendDailyRecipeNotification();
        },
      ),
    );
  }
}
