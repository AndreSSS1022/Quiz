import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../auth_service.dart';
import 'userprofile.dart';
import 'storeprofile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _jwt;
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  int _selectedIndex = 0;
  int? _selectedBarIndex;

  final Color darkBlue = const Color(0xFF0A2342);
  final Color midBlue = const Color(0xFF185ADB);
  final Color bgBlue = const Color(0xFF1B263B);
  final Color cardBlue = const Color(0xFF222B45);
  final Color accentYellow = const Color(0xFFFFD93D);

  final List<Map<String, dynamic>> bars = [
    {
      'image': 'assets/bar1.jpg',
      'name': 'Dakiti Club',
      'address': 'Carrera 22 #52, Bogotá',
      'distance': '800 m',
      'tags': ['Reggaetón', 'Crossover'],
      'desc': 'Un club con ambiente crossover y la mejor música para bailar toda la noche.',
    },
    {
      'image': 'assets/bar2.jpg',
      'name': 'Theatron',
      'address': 'Calle 58 Bis #10 - 32, Bogotá',
      'distance': '1,2 km',
      'tags': ['Electrónica', 'Pop', 'Fusión'],
      'desc': 'El club más grande de Latinoamérica, con múltiples ambientes y géneros.',
    },
  ];

  int _currentBar = 0;

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await AuthService().getToken();
    setState(() {
      _jwt = token;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedBarIndex = null; // cerrar detalle de bar al cambiar sección
    });
  }

  void _openBarDetail(int index) {
    setState(() {
      _selectedBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredBars = _searchText.isEmpty
        ? bars
        : bars.where((bar) {
            final name = bar['name'].toString().toLowerCase();
            final address = bar['address'].toString().toLowerCase();
            return name.contains(_searchText) || address.contains(_searchText);
          }).toList();

    if (_jwt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inicio')),
        body: const Center(child: Text('No autenticado')),
      );
    }

    // Vistas de cada sección
    final List<Widget> _pages = [
      // Home
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_searchText.isEmpty) ...[
            CarouselSlider(
              items: bars.map((bar) {
                int index = bars.indexOf(bar);
                return GestureDetector(
                  onTap: () => _openBarDetail(index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(bar['image'], fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bar['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 16,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  bar['desc'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 210,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentBar = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...filteredBars.map((bar) => GestureDetector(
                onTap: () => _openBarDetail(bars.indexOf(bar)),
                child: BarCard(
                  image: bar['image'],
                  name: bar['name'],
                  address: bar['address'],
                  distance: bar['distance'],
                  tags: List<String>.from(bar['tags']),
                  midBlue: midBlue,
                  darkBlue: darkBlue,
                  accentYellow: accentYellow,
                  cardBlue: cardBlue,
                ),
              )),
          if (filteredBars.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No se encontraron bares.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
      Center(child: Text('Favoritos', style: TextStyle(color: Colors.white, fontSize: 24))),
      const UserProfile(),
      Center(child: Text('Contacto', style: TextStyle(color: Colors.white, fontSize: 24))),
      Center(child: Text('Notificaciones', style: TextStyle(color: Colors.white, fontSize: 24))),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [midBlue, darkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
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
                        cursorColor: midBlue,
                        decoration: const InputDecoration(
                          hintText: 'Buscar fiestas...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    )
                  : Text(
                      widget.title,
                      key: const ValueKey('title'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 1.5,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(_showSearch ? Icons.close : Icons.search, color: Colors.white),
                onPressed: _toggleSearch,
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [midBlue, darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: midBlue),
              title: const Text('Perfil'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                  _selectedBarIndex = null;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await AuthService().logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      backgroundColor: bgBlue,
      // Reemplaza la parte del IndexedStack en tu Scaffold
body: IndexedStack(
  index: _selectedBarIndex != null ? 5 : _selectedIndex, // índice 5 reservado para detalle
  children: [
    ..._pages, // tus páginas principales: Home, Favoritos, Perfil, etc.
    if (_selectedBarIndex != null)
      Scaffold(
        appBar: AppBar(
          backgroundColor: darkBlue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _selectedBarIndex = null; // volver al home
              });
            },
          ),
          title: Text(bars[_selectedBarIndex!]['name']),
          centerTitle: true,
        ),
        body: StoreProfile(
          name: bars[_selectedBarIndex!]['name'],
          image: bars[_selectedBarIndex!]['image'],
          address: bars[_selectedBarIndex!]['address'],
          description: bars[_selectedBarIndex!]['desc'],
          tags: List<String>.from(bars[_selectedBarIndex!]['tags']),
        ),
      ),
  ],
),


// Tarjeta de bar
class BarCard extends StatelessWidget {
  final String image;
  final String name;
  final String address;
  final String distance;
  final List<String> tags;
  final Color midBlue;
  final Color darkBlue;
  final Color accentYellow;
  final Color cardBlue;

  const BarCard({
    super.key,
    required this.image,
    required this.name,
    required this.address,
    required this.distance,
    required this.tags,
    required this.midBlue,
    required this.darkBlue,
    required this.accentYellow,
    required this.cardBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(color: accentYellow, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(address, style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: tags.map((tag) => Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 12)),
                      backgroundColor: midBlue,
                    )).toList(),
                  ),
                ],
              ),
            ),
            Text(distance, style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
