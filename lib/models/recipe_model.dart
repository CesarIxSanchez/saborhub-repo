// Molde para cada receta
class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String difficulty;
  final String time;
  final List<String> ingredients;
  final List<String> steps; 
  final String videoUrl;
  final String videoAuthor;

  const Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.difficulty,
    required this.time,
    required this.ingredients,
    required this.steps,
    required this.videoUrl,
    required this.videoAuthor,
  });
}