
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../auth_service.dart';

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
    {
      'image': 'assets/bar3.jpg',
      'name': 'Clandestino',
      'address': 'Calle 84A # 12-50, Bogotá',
      'distance': '2 km',
      'tags': ['Salsa', 'Latino', 'Crossover'],
      'desc': 'Perfecto para los amantes de la salsa y la música latina.',
    },
    {
      'image': 'assets/bar4.jpg',
      'name': 'La Negra',
      'address': 'Calle 100 #15-20, Bogotá',
      'distance': '2,5 km',
      'tags': ['Latino', 'Caribeña'],
      'desc': 'Ambiente caribeño y ritmos latinos para disfrutar con amigos.',
    },
    {
      'image': 'assets/bar5.jpg',
      'name': 'Presea Bar',
      'address': 'Cra 13 #50-60, Bogotá',
      'distance': '3 km',
      'tags': ['Techno', 'After Party'],
      'desc': 'El mejor after party con DJs de techno y ambiente underground.',
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
                        cursorColor: midBlue,
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
                        fontSize: 28,
                        letterSpacing: 1.5,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(_showSearch ? Icons.close : Icons.search, color: Colors.white),
                onPressed: _toggleSearch,
                tooltip: _showSearch ? 'Cerrar búsqueda' : 'Buscar',
              ),
            ],
            toolbarHeight: 70,
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
              leading: Icon(Icons.person, color: midBlue, size: 28),
              title: const Text('Perfil', style: TextStyle(fontSize: 18)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.category, color: midBlue, size: 28),
              title: const Text('Categorías', style: TextStyle(fontSize: 18)),
              onTap: () { Navigator.pop(context);
              Navigator.pushNamed(context, '/categories');
              }, 

            ),
            ListTile(
              leading: Icon(Icons.book_online, color: midBlue, size: 28),
              title: const Text('Reservas', style: TextStyle(fontSize: 18)),
              onTap: () { Navigator.pop(context);
              Navigator.pushNamed(context, '/bookings'); 
              },   
              
              
            ),
            ListTile(
              leading: Icon(Icons.settings, color: midBlue, size: 28),
              title: const Text('Ajustes', style: TextStyle(fontSize: 18)),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red, size: 28),
              title: const Text('Cerrar sesión', style: TextStyle(fontSize: 18, color: Colors.red)),
              onTap: () async {
                await AuthService().logout();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_searchText.isEmpty) ...[
            CarouselSlider(
              items: bars.map((bar) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        bar['image'],
                        fit: BoxFit.cover,
                      ),
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
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
          ...filteredBars.map((bar) => Column(
                children: [
                  BarCard(
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
                  const SizedBox(height: 16),
                ],
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: midBlue,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 0 ? midBlue : Colors.white,
              child: Icon(Icons.place, color: _selectedIndex == 0 ? Colors.white : Colors.black),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 1 ? midBlue : Colors.white,
              child: Icon(Icons.favorite, color: _selectedIndex == 1 ? Colors.white : Colors.black),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 2 ? midBlue : Colors.white,
              child: Icon(Icons.person, color: _selectedIndex == 2 ? Colors.white : Colors.black),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 3 ? midBlue : Colors.white,
              child: Icon(Icons.phone, color: _selectedIndex == 3 ? Colors.white : Colors.black),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 4 ? midBlue : Colors.white,
              child: Icon(Icons.notifications, color: _selectedIndex == 4 ? Colors.white : Colors.black),
            ),
            label: '',
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
      elevation: 6,
      color: cardBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: midBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: accentYellow),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 15, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.access_time, size: 18, color: midBlue),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: const TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) {
                    Color chipColor = midBlue;
                    if (tag.toLowerCase().contains('electrónica')) chipColor = darkBlue;
                    if (tag.toLowerCase().contains('salsa')) chipColor = accentYellow;
                    if (tag.toLowerCase().contains('reggaetón')) chipColor = midBlue;
                    if (tag.toLowerCase().contains('techno')) chipColor = darkBlue;
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: chipColor,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}