import 'package:flutter/material.dart';
import '../models/mealDetail.dart';

class MealDetailsScreen extends StatelessWidget {
  final MealDetail meal;

  const MealDetailsScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(meal.thumbnail),
            ),
            const SizedBox(height: 20),

            Text(
              meal.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            const Text("Ingredients:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            ...meal.ingredients.entries.map(
                  (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "• ${e.key}: ${e.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF76D7C4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 20),
            const Text("Instructions:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            Text(meal.instructions),

            const SizedBox(height: 20),
            if (meal.youtubeLink != null && meal.youtubeLink!.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                },
                child: const Text("Watch on YouTube"),
              ),
          ],
        ),
      ),
    );
  }
}
