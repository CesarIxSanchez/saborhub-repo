import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Recipe> _favoriteRecipes = [];

  List<Recipe> get favoriteRecipes => _favoriteRecipes;

  bool isFavorite(Recipe recipe) {
    return _favoriteRecipes.any((item) => item.id == recipe.id);
  }

  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe)) {
      _favoriteRecipes.removeWhere((item) => item.id == recipe.id);
    } else {
      _favoriteRecipes.add(recipe);
    }
    notifyListeners();
  }
}