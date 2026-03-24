import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_api_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Fetch random meal suggestions
  Future<List<MealApiModel>> getRandomMeals({int count = 6}) async {
    try {
      final List<MealApiModel> meals = [];

      // TheMealDB free API returns 1 random meal per call
      // We call it multiple times for variety
      for (int i = 0; i < count; i++) {
        final response = await http.get(Uri.parse('$_baseUrl/random.php'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['meals'] != null) {
            for (var meal in data['meals']) {
              meals.add(MealApiModel.fromJson(meal));
            }
          }
        }
      }

      return meals;
    } catch (e) {
      print('Error fetching random meals: $e');
      rethrow;
    }
  }

  // Search meals by name
  Future<List<MealApiModel>> searchMeals(String query) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => MealApiModel.fromJson(meal))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load meals (${response.statusCode})');
      }
    } catch (e) {
      print('Error searching meals: $e');
      rethrow;
    }
  }

  // Fetch meals by category
  Future<List<MealApiModel>> getMealsByCategory(String category) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/filter.php?c=$category'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List).map((meal) {
            return MealApiModel(
              id: meal['idMeal'] ?? '',
              name: meal['strMeal'] ?? '',
              thumbnail: meal['strMealThumb'] ?? '',
              category: category,
              area: '',
              instructions: '',
            );
          }).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load meals (${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching meals by category: $e');
      rethrow;
    }
  }

  // Get all food categories
  Future<List<String>> getCategories() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/categories.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['categories'] != null) {
          return (data['categories'] as List)
              .map((cat) => cat['strCategory'] as String)
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load categories (${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }
}
