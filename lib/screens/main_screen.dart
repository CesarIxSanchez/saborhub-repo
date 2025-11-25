import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saborhub/providers/favorites_provider.dart';
import 'package:saborhub/providers/recipes_provider.dart'; 
import 'package:saborhub/screens/add_recipe_screen.dart'; 
import 'package:saborhub/screens/recipe_list_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesProvider = context.watch<RecipesProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bienvenido 👋',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      Text('¿Qué deseas cocinar hoy?',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    ],
                  ),
                  // Botón +
                  IconButton.filled(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRecipeScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Categorias
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _MenuCard(
                            title: 'Mixtas',
                            count: recipesProvider.mixedRecipes.length, // Muestra contador
                            icon: Icons.restaurant_menu,
                            color: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeListScreen(
                                    title: 'Recetas Mixtas',
                                    recipes: recipesProvider.mixedRecipes, // Usamos la lista dinámica
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _MenuCard(
                            title: 'Veganas',
                            count: recipesProvider.veganRecipes.length,
                            icon: Icons.eco,
                            color: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeListScreen(
                                    title: 'Recetas Veganas',
                                    recipes: recipesProvider.veganRecipes,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    // Favortios
                    _MenuCard(
                      title: 'Mis Favoritos',
                      icon: Icons.favorite,
                      color: Colors.redAccent,
                      isWide: true, 
                      onTap: () {
                         final favoriteRecipes =
                            context.read<FavoritesProvider>().favoriteRecipes;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeListScreen(
                              title: 'Mis Favoritos',
                              recipes: favoriteRecipes,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isWide;
  final int? count;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isWide = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isWide ? 100 : 160, 
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isWide 
        ? Row( 
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 20),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[300], size: 20)
            ],
          )
        : Column( 
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if(count != null)
                  Text('$count recetas', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                ],
              )
            ],
          ),
      ),
    );
  }
}