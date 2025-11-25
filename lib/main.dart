import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saborhub/providers/favorites_provider.dart';
import 'package:saborhub/screens/main_screen.dart';
import 'package:saborhub/providers/recipes_provider.dart';

void main() {
  runApp(
    MultiProvider( // fovoritos y guardar
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => RecipesProvider()), 
      ],
      child: const SaborHubApp(),
    ),
  );
}

class SaborHubApp extends StatelessWidget {
  const SaborHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaborHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}