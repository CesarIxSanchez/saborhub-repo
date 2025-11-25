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

  //  Convertir a JSON para poder guardar
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'difficulty': difficulty,
      'time': time,
      'ingredients': ingredients,
      'steps': steps,
      'videoUrl': videoUrl,
      'videoAuthor': videoAuthor,
    };
  }

  // Crear desde el JSON 
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      difficulty: map['difficulty'],
      time: map['time'],
      ingredients: List<String>.from(map['ingredients']),
      steps: List<String>.from(map['steps']),
      videoUrl: map['videoUrl'] ?? '',
      videoAuthor: map['videoAuthor'] ?? '',
    );
  }
}