# SaborHub

¡Tu hub de recetas deliciosas! SaborHub es una aplicación móvil multiplataforma (iOS y Android) desarrollada en Flutter, diseñada para ser tu compañero de cocina personal. Descubre, guarda y prepara recetas increíbles.

## Integrantes

- César Antonio Ix Sánchez
    - GitHub: [@CesarIxSanchez](https://github.com/CesarIxSanchez)

- Cristian Giovany Carballo Padilla
    - GitHub: [@BocchiGio](https://github.com/BocchiGio)

## Características principales

- Navegación intuitiva: Interfaz limpia con navegación clara entre pantallas usando Navigator.push y Navigator.pop.

- Listas de recetas: Secciones separadas para recetas mixtas y recetas veganas.

- Detalle de receta: Un "molde" de receta robusto que muestra:

    - Imagen (cargada desde URL)

    - Grado de dificultad y tiempo estimado

    - Lista de ingredientes

    - Pasos de preparación numerados

    - Enlace al video de YouTube (se abre dentro de la app)

- Sistema de favoritos:

    - Guarda tus recetas preferidas con un toque.

    - Una pantalla dedicada de Mis favoritos muestra todas las recetas que has marcado.

    - El estado se maneja globalmente usando ChangeNotifierProvider.

## Estructura del proyecto

El proyecto está organizado con una arquitectura limpia para facilitar la escalabilidad:

lib/
├── data/
│   └── recipe_data.dart     # (Contiene los datos "crudos" de todas las recetas)
├── models/
│   └── recipe_model.dart    # (Define la clase "molde" de la Receta)
├── providers/
│   └── favorites_provider.dart # (Maneja el estado global de los favoritos)
├── screens/
│   ├── main_screen.dart         # (Pantalla 1: Inicio)
│   ├── recipe_list_screen.dart  # (Pantalla 2: Lista de recetas mixtas/veganas/favoritos)
│   └── recipe_detail_screen.dart # (Pantalla 3: Detalle de una receta)
└── main.dart                    # (Punto de entrada: Configura Provider y MaterialApp)