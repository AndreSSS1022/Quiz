import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final Color darkBlue = const Color(0xFF0A2342);
  final Color midBlue = const Color(0xFF185ADB);
  final Color bgBlue = const Color(0xFF1B263B);
  final Color cardBlue = const Color(0xFF222B45);
  final Color accentYellow = const Color(0xFFFFD93D);

  // Categorías de música
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Reggaetón',
      'icon': Icons.music_note,
      'color': Color(0xFFFF6B6B),
      'count': 12,
      'description': 'Ritmo latino y urbano',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    },
    {
      'name': 'Electrónica',
      'icon': Icons.electrical_services,
      'color': Color(0xFF4ECDC4),
      'count': 8,
      'description': 'Beats electrónicos',
      'gradient': [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    },
    {
      'name': 'Salsa',
      'icon': Icons.music_note_rounded,
      'color': Color(0xFFFFA07A),
      'count': 15,
      'description': 'Música tropical',
      'gradient': [Color(0xFFFFA07A), Color(0xFFFF7F50)],
    },
    {
      'name': 'Rock',
      'icon': Icons.music_video,
      'color': Color(0xFF95E1D3),
      'count': 6,
      'description': 'Rock y alternativo',
      'gradient': [Color(0xFF95E1D3), Color(0xFF38ADA9)],
    },
    {
      'name': 'Pop',
      'icon': Icons.star,
      'color': Color(0xFFE056FD),
      'count': 10,
      'description': 'Música comercial',
      'gradient': [Color(0xFFE056FD), Color(0xFFC471F5)],
    },
    {
      'name': 'Latino',
      'icon': Icons.favorite,
      'color': Color(0xFFF7B731),
      'count': 18,
      'description': 'Ritmos latinos',
      'gradient': [Color(0xFFF7B731), Color(0xFFFFA502)],
    },
    {
      'name': 'Techno',
      'icon': Icons.auto_graph,
      'color': Color(0xFF5F27CD),
      'count': 7,
      'description': 'Techno y house',
      'gradient': [Color(0xFF5F27CD), Color(0xFF341F97)],
    },
    {
      'name': 'Crossover',
      'icon': Icons.shuffle,
      'color': Color(0xFF00D2FF),
      'count': 14,
      'description': 'Mezcla de géneros',
      'gradient': [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
    },
  ];

  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      appBar: AppBar(
        title: const Text('Categorías'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [midBlue, darkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con información
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Encuentra tu estilo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explora bares por género musical',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Grid de categorías
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category['name'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = isSelected ? '' : category['name'];
                    });
                    
                    // Mostrar snackbar con la categoría seleccionada
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Buscando bares de ${category['name']}...',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: category['color'],
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    
                    // Aquí podrías navegar a una vista filtrada de bares
                    // Navigator.pushNamed(context, '/bars-by-category', arguments: category['name']);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..scale(isSelected ? 1.05 : 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: category['gradient'],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: category['color'].withOpacity(0.4),
                            blurRadius: isSelected ? 20 : 12,
                            offset: Offset(0, isSelected ? 8 : 4),
                          ),
                        ],
                        border: Border.all(
                          color: isSelected 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.1),
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Icono de fondo decorativo
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Icon(
                              category['icon'],
                              size: 120,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          
                          // Contenido
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Icono principal
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    category['icon'],
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                                
                                // Información
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      category['description'],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${category['count']} bares',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Indicador de selección
                          if (isSelected)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 20,
                                  color: category['color'],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Botón de filtrar (si hay categoría seleccionada)
          if (selectedCategory.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Aquí navegarías a la vista de bares filtrados
                      Navigator.pop(context); // Por ahora vuelve al home
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Mostrando bares de $selectedCategory',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: midBlue,
                        ),
                      );
                    },
                    icon: const Icon(Icons.filter_list, size: 24),
                    label: Text(
                      'Ver bares de $selectedCategory',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentYellow,
                      foregroundColor: darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}