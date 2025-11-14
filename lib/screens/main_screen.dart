import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saborhub/data/recipe_data.dart';
import 'package:saborhub/providers/favorites_provider.dart';
import 'package:saborhub/screens/recipe_list_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaborHub'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Recetas mixtas'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeListScreen(
                        title: 'Recetas mixtas',
                        recipes: allMixedRecipes,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              
              ElevatedButton.icon(
                icon: const Icon(Icons.eco),
                label: const Text('Recetas veganas'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeListScreen(
                        title: 'Recetas veganas',
                        recipes: allVeganRecipes,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              
              ElevatedButton.icon(
                icon: const Icon(Icons.favorite),
                label: const Text('Mis favoritos'),
                onPressed: () {
                  final favoriteRecipes =
                      context.read<FavoritesProvider>().favoriteRecipes;
                      
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeListScreen(
                        title: 'Mis favoritos',
                        recipes: favoriteRecipes,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}