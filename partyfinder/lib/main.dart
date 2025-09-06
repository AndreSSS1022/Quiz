import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Finder', 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 58, 68, 183)),
      ),
      home: const MyHomePage(title: 'Party Finder'), 
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3A44B7), Color(0xFF6C63FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Cerrar menú',
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: AssetImage('assets/perfil.JPG'),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: 12),
                        Text(
                          '¡Hola, Andres!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'andres@gmail.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFF3A44B7), size: 28),
                    title: const Text('Perfil', style: TextStyle(fontSize: 18)),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.category, color: Color(0xFF6C63FF), size: 28),
                    title: const Text('Categorías', style: TextStyle(fontSize: 18)),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.book_online, color: Color(0xFF3A44B7), size: 28),
                    title: const Text('Reservas', style: TextStyle(fontSize: 18)),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Color(0xFF6C63FF), size: 28),
                    title: const Text('Ajustes', style: TextStyle(fontSize: 18)),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 39, 176),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menú',
          ),
        ),
        centerTitle: true,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: child,
            ),
          ),
          child: _showSearch
              ? SizedBox(
                  key: const ValueKey('searchField'),
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: 'Buscar fiestas...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                    onSubmitted: (value) {},
                  ),
                )
              : Text(
                  widget.title,
                  key: const ValueKey('title'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
            tooltip: _showSearch ? 'Cerrar búsqueda' : 'Buscar',
          ),
        ],
        elevation: 4,
        toolbarHeight: 64, 
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BarCard(
            image: 'assets/bar1.jpg',
            name: 'Dakiti Club',
            address: 'Carrera 22 #52, Bogotá',
            distance: '800 m',
            tags: const ['Crossover'],
          ),
          const SizedBox(height: 16),
          BarCard(
            image: 'assets/bar2.jpg',
            name: 'Theatron',
            address: 'Calle 58 Bis #10 - 32, Bogotá',
            distance: '1,2 km',
            tags: const ['Croosver', 'Pop', 'Electrónica'],
          ),
          const SizedBox(height: 16),
          BarCard(
            image: 'assets/bar3.jpg',
            name: 'Clandestino',
            address: 'Calle 84A # 12-50, Bogotá',
            distance: '2 km',
            tags: const ['Salsa', 'Latino','crossover'],
          ),
          const SizedBox(height: 16),
          BarCard(
            image: 'assets/bar4.jpg',
            name: 'La Negra',
            address: 'Calle 100 #15-20, Bogotá',
            distance: '2,5 km',
            tags: const ['Latino', 'Caribeña'],
          ),
          const SizedBox(height: 16),
          BarCard(
            image: 'assets/bar5.jpg',
            name: 'Presea Bar',
            address: 'Cra 13 #50-60, Bogotá',
            distance: '3 km',
            tags: const ['Techno', 'After Party'],
          ),
        ],
      ),
    );
  }
}

class BarCard extends StatelessWidget {
  final String image;
  final String name;
  final String address;
  final String distance;
  final List<String> tags;

  const BarCard({
    super.key,
    required this.image,
    required this.name,
    required this.address,
    required this.distance,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: const Color(0xFFE0E0E0),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
