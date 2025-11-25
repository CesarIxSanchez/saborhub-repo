import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:provider/provider.dart';
import 'package:saborhub/models/recipe_model.dart';
import 'package:saborhub/providers/recipes_provider.dart';

class AddRecipeScreen extends StatefulWidget {
  final bool? isVeganDefault;

  const AddRecipeScreen({super.key, this.isVeganDefault});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  
  bool _isVegan = false;
  String _selectedDifficulty = 'Fácil';
  final List<String> _difficultyOptions = ['Fácil', 'Media', 'Difícil'];

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // FUNCIÓN PARA PEDIR PERMISO Y ABRIR GALERÍA 
  Future<void> _pickImage() async {
    // Pedimos permiso explícitamente
    // En Android 13+ se usa 'photos', en anteriores 'storage'
    // Librería para manejar diferencia automáticamente.
    var status = await Permission.photos.request();

    if (status.isGranted || await Permission.storage.request().isGranted) {
      //  Si dice que sí, abrir galería
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } else {
      // Si dice que no, mostramos alerta
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se necesitan permisos para acceder a la galería'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isVeganDefault != null) {
      _isVegan = widget.isVeganDefault!;
    }
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      
      String finalImagePath;

      if (_selectedImage != null) {
        final recipesProvider = context.read<RecipesProvider>();
        finalImagePath = await recipesProvider.saveImageLocally(_selectedImage!);
      } else {
        finalImagePath = 'https://via.placeholder.com/300?text=Sin+Imagen';
      }

      String timeString;
      int hours = int.tryParse(_hoursController.text) ?? 0;
      int minutes = int.tryParse(_minutesController.text) ?? 0;

      if (hours > 0 && minutes > 0) {
        timeString = '$hours h $minutes min';
      } else if (hours > 0) {
        timeString = '$hours h';
      } else if (minutes > 0) {
        timeString = '$minutes min';
      } else {
        timeString = '30 min';
      }

      final newRecipe = Recipe(
        id: DateTime.now().toString(),
        title: _titleController.text,
        imageUrl: finalImagePath,
        difficulty: _selectedDifficulty,
        time: timeString, 
        ingredients: _ingredientsController.text.split('\n'), 
        steps: _stepsController.text.split('\n'),
        videoUrl: _videoUrlController.text,
        videoAuthor: 'Usuario',
      );

      if (!mounted) return;
      
      context.read<RecipesProvider>().addRecipe(newRecipe, _isVegan);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Receta guardada en el teléfono!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Receta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.isVeganDefault == null)
                SwitchListTile(
                  title: const Text('¿Es receta Vegana?'),
                  value: _isVegan,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => _isVegan = val),
                ),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Platillo', 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (value) => value!.isEmpty ? 'Ponle nombre' : null,
              ),
              const SizedBox(height: 15),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                            Text('Agregar foto'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 15),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: DropdownButtonFormField<String>(
                      value: _selectedDifficulty,
                      isExpanded: true,
                      items: _difficultyOptions.map((e) => DropdownMenuItem(
                        value: e, 
                        child: Text(e, overflow: TextOverflow.ellipsis)
                      )).toList(),
                      onChanged: (val) => setState(() => _selectedDifficulty = val!),
                      decoration: const InputDecoration(
                        labelText: 'Dificultad', 
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  Expanded(
                    flex: 5,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tiempo', 
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _hoursController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'Hrs', 
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              ':', 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _minutesController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'Min', 
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _videoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Link de YouTube (Opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.video_library),
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredientes (Uno por línea)',
                  hintText: 'Ejemplo:\n1kg de Harina\n2 Huevos\nUna pizca de sal',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Pasos de preparación (Uno por línea)',
                  hintText: 'Ejemplo:\nLavar las verduras\nCortar en cubos\nCocinar por 20 min\nServir caliente',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 7,
                keyboardType: TextInputType.multiline,
              ),
              
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveRecipe,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Receta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVegan ? Colors.green : Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}