import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saborhub/models/recipe_model.dart';
import 'package:saborhub/providers/favorites_provider.dart';
import 'package:saborhub/providers/recipes_provider.dart';
import 'package:saborhub/screens/recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  final String title;
  final List<Recipe> recipes;

  const RecipeListScreen({
    super.key,
    required this.title,
    required this.recipes,
  });

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = widget.recipes.where((recipe) {
      final titleLower = recipe.title.toLowerCase();
      final searchLower = _searchText.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar receta...',
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
        ),
      ),
      body: filteredRecipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text(
                    'Receta no encontrada',
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                
                return Dismissible(
                  key: Key(recipe.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),

                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("¿Eliminar receta?"),
                          content: Text("¿Estás seguro de eliminar '${recipe.title}'?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false), 
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true), 
                              child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },

                  onDismissed: (direction) {
                    bool isVegan = widget.title.toLowerCase().contains('vegan');
                    if (widget.title == 'Mis Favoritos') {
                       context.read<FavoritesProvider>().toggleFavorite(recipe);
                    } else {
                       context.read<RecipesProvider>().deleteRecipe(recipe.id, isVegan);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${recipe.title} eliminada')),
                    );
                  },
                  child: RecipeCard(recipe: recipe),
                );
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: recipe.imageUrl.startsWith('http')
                  ? Image.network( // Si es URL
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.grey[300], child: const Icon(Icons.broken_image));
                      },
                    )
                  : Image.file( // Si es archivo local 
                      File(recipe.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported));
                      },
                    ),
            ),
            // -----------------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(recipe.time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(width: 10),
                        Icon(Icons.bar_chart, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(recipe.difficulty, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}