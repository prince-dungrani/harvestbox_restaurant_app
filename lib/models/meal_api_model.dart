class MealApiModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String? tags;

  MealApiModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    this.tags,
  });

  factory MealApiModel.fromJson(Map<String, dynamic> json) {
    return MealApiModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      tags: json['strTags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnail,
      'strTags': tags,
    };
  }
}
