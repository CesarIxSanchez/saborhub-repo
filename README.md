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
