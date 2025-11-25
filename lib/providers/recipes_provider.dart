import 'dart:convert'; 
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:saborhub/data/recipe_data.dart';
import '../models/recipe_model.dart';

class RecipesProvider with ChangeNotifier {
  List<Recipe> _mixedRecipes = [];
  List<Recipe> _veganRecipes = [];

  List<Recipe> get mixedRecipes => _mixedRecipes;
  List<Recipe> get veganRecipes => _veganRecipes;


  RecipesProvider() {
    _loadData();
  }

  // Cargar
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    

    final String? mixedString = prefs.getString('mixed_recipes');
    if (mixedString != null) {
      List<dynamic> decoded = jsonDecode(mixedString);
      _mixedRecipes = decoded.map((item) => Recipe.fromMap(item)).toList();
    } else {
      _mixedRecipes = [...allMixedRecipes];
    }

    final String? veganString = prefs.getString('vegan_recipes');
    if (veganString != null) {
      List<dynamic> decoded = jsonDecode(veganString);
      _veganRecipes = decoded.map((item) => Recipe.fromMap(item)).toList();
    } else {
      _veganRecipes = [...allVeganRecipes];
    }
    notifyListeners();
  }

  // Guardar
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Lista a json
    String mixedEncoded = jsonEncode(_mixedRecipes.map((r) => r.toMap()).toList());
    String veganEncoded = jsonEncode(_veganRecipes.map((r) => r.toMap()).toList());

    // Guardar en el telefono 
    await prefs.setString('mixed_recipes', mixedEncoded);
    await prefs.setString('vegan_recipes', veganEncoded);
  }

  // Guardar la foto de la receta
  Future<String> saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    
    // nombre para la foto
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    // copiar la foto a la carpeta de la app
    final File localImage = await imageFile.copy('${directory.path}/$fileName');
    
    return localImage.path; // nueva ruta de la imagen
  }

  // Añadir
  Future<void> addRecipe(Recipe recipe, bool isVegan) async {
    if (isVegan) {
      _veganRecipes.add(recipe);
    } else {
      _mixedRecipes.add(recipe);
    }
    notifyListeners();
    _saveData(); 
  }

  // Borrar
  Future<void> deleteRecipe(String id, bool isVegan) async {
    if (isVegan) {
      _veganRecipes.removeWhere((recipe) => recipe.id == id);
    } else {
      _mixedRecipes.removeWhere((recipe) => recipe.id == id);
    }
    notifyListeners();
    _saveData();
  }
}