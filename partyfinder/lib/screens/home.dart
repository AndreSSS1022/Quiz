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
  int _selectedIndex = 0; // Este es el índice que controla la navegación

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

  // --- NUEVO: LISTA DE PANTALLAS PARA LA NAVEGACIÓN ---
  // El índice 0 será el contenido original de esta pantalla.
  // El índice 1 será la nueva pantalla de sensores/mapa.
  // Los demás son placeholders que puedes reemplazar después.
  List<Widget> _buildScreens() {
    return [
      _buildHomeScreenContent(), // El contenido de la lista de bares (Índice 0
      const Center(child: Text('Pantalla de Favoritos (próximamente)')), // Índice 2
      const Center(child: Text('Pantalla de Perfil (próximamente)')),   // Índice 3
    ];
  }
  // --- FIN DE LA SECCIÓN NUEVA ---


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

  // --- NUEVO: Widget que construye el contenido original de la home page ---
  Widget _buildHomeScreenContent() {
    final filteredBars = _searchText.isEmpty
        ? bars
        : bars.where((bar) {
      final name = bar['name'].toString().toLowerCase();
      final address = bar['address'].toString().toLowerCase();
      return name.contains(_searchText) || address.contains(_searchText);
    }).toList();

    return ListView(
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
        ...filteredBars.map((bar) => Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Image.asset(
                bar['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover
            ),
            title: Text(bar['name']),
            subtitle: Text(bar['address']),
            trailing: Text(bar['distance']),
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
    );
  }
  // --- FIN DE LA SECCIÓN NUEVA ---


  @override
  Widget build(BuildContext context) {
    if (_jwt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inicio')),
        body: const Center(child: Text('No autenticado')),
      );
    }

    final screens = _buildScreens();

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
              leading: Icon(Icons.location_on, color: midBlue, size: 28),
              title: const Text('Localización', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/location_sensor');
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

      // --- CAMBIO PRINCIPAL: El body ahora muestra la pantalla correcta ---
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      // --- FIN DEL CAMBIO ---

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
          // ÍNDICE 0: Le he cambiado el ícono a 'home' para que sea más claro
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 0 ? midBlue : Colors.white,
              child: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.white : Colors.black),
            ),
            label: 'Inicio',
          ),
          // ÍNDICE 1: El ícono del mapa que mostrará tu pantalla de sensores
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 1 ? midBlue : Colors.white,
              child: Icon(Icons.map_outlined, color: _selectedIndex == 1 ? Colors.white : Colors.black),
            ),
            label: 'Mapa',
          ),
          // ÍNDICE 2: Favoritos
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 2 ? midBlue : Colors.white,
              child: Icon(Icons.favorite, color: _selectedIndex == 2 ? Colors.white : Colors.black),
            ),
            label: 'Favoritos',
          ),
          // ÍNDICE 3: Perfil
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _selectedIndex == 3 ? midBlue : Colors.white,
              child: Icon(Icons.person, color: _selectedIndex == 3 ? Colors.white : Colors.black),
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Nota: El widget 'BarCard' no está definido en este archivo.
// Si te da un error, coméntalo temporalmente o asegúrate de que esté definido.
