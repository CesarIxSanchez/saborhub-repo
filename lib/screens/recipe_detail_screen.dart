import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saborhub/models/recipe_model.dart';
import 'package:saborhub/providers/favorites_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // Marcar ingredientes
  final Set<String> _checkedIngredients = {};
  
  // Pasos completados
  final Set<int> _completedSteps = {};

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.recipe.title),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final bool isFavorite = favoritesProvider.isFavorite(widget.recipe);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavorite(widget.recipe);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen
            SizedBox(
              height: 250,
              child: widget.recipe.imageUrl.startsWith('http')
                  ? Image.network(
                      widget.recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    )
                  : Image.file(
                      File(widget.recipe.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
            ),
            const SizedBox(height: 10),

            // Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoChip(icon: Icons.thermostat, text: widget.recipe.difficulty),
                  InfoChip(icon: Icons.timer, text: widget.recipe.time),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Ingredientes
            const SectionTitle(title: 'Ingredientes'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: widget.recipe.ingredients.map((ingredient) {
                  final isChecked = _checkedIngredients.contains(ingredient);
                  return CheckboxListTile(
                    title: Text(
                      ingredient,
                      style: TextStyle(
                        decoration: isChecked ? TextDecoration.lineThrough : null,
                        color: isChecked ? Colors.grey : Colors.black87,
                      ),
                    ),
                    value: isChecked,
                    activeColor: Colors.green,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _checkedIngredients.add(ingredient);
                        } else {
                          _checkedIngredients.remove(ingredient);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Pasos
            const SectionTitle(title: 'Pasos'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.recipe.steps.length,
              itemBuilder: (context, index) {
                // Paso terminado
                final isStepDone = _completedSteps.contains(index);

                return ListTile(
                  // Marcar/desmarcar al tocar
                  onTap: () {
                    setState(() {
                      if (isStepDone) {
                        _completedSteps.remove(index);
                      } else {
                        _completedSteps.add(index);
                      }
                    });
                  },
                  leading: CircleAvatar(
                    // gris = listo
                    backgroundColor: isStepDone ? Colors.grey : Colors.green,
                    foregroundColor: Colors.white,
                    child: isStepDone
                        ? const Icon(Icons.check, size: 20) // Palomita si está listo
                        : Text('${index + 1}'), // Número si falta
                  ),
                  title: Text(
                    widget.recipe.steps[index],
                    style: TextStyle(
                      // Tachar el texto si está listo
                      decoration: isStepDone ? TextDecoration.lineThrough : null,
                      color: isStepDone ? Colors.grey : Colors.black87,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Video
            if (widget.recipe.videoUrl.isNotEmpty) ...[
              const SectionTitle(title: 'Video de Preparación'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Ver en YouTube'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _launchURL(widget.recipe.videoUrl),
                    ),
                    const SizedBox(height: 10),
                    if (widget.recipe.videoAuthor.isNotEmpty)
                      Text(
                        'Créditos del video: ${widget.recipe.videoAuthor}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: Colors.green),
      label: Text(text),
      backgroundColor: Colors.green.withOpacity(0.1),
      side: BorderSide.none,
    );
  }
}