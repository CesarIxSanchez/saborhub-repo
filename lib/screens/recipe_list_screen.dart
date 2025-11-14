import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saborhub/models/recipe_model.dart';
import 'package:saborhub/providers/favorites_provider.dart';
import 'package:saborhub/screens/recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;

  const RecipeListScreen({
    super.key,
    required this.title,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoritesProvider>();
    
    final List<Recipe> displayRecipes = title == 'Mis Favoritos'
        ? favoriteProvider.favoriteRecipes
        : recipes;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: displayRecipes.isEmpty
          ? Center(
              child: Text(
                'No hay recetas en esta sección.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : ListView.builder(
              itemCount: displayRecipes.length,
              itemBuilder: (context, index) {
                final recipe = displayRecipes[index];
                return RecipeCard(recipe: recipe);
              },
            ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              recipe.imageUrl,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                recipe.title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}