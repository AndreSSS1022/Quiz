import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181824), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00F6FF), 
          brightness: Brightness.dark,
          primary: const Color(0xFF00F6FF),   
          secondary: const Color(0xFFFF00A6), 
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        cardColor: const Color(0xFF232336), 
      ),
      home: const MyHomePage(title: 'PartyFinder'),
      debugShowCheckedModeBanner: false,
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
  String _searchText = '';

  
  final Color neonBlue = const Color(0xFF00F6FF);
  final Color neonPink = const Color(0xFFFF00A6);
  final Color neonPurple = const Color(0xFF8A2BE2);
  final Color neonGreen = const Color(0xFF39FF14);
  final Color neonYellow = const Color(0xFFFFD93D);
  final Color darkBg = const Color(0xFF181824);
  final Color cardBg = const Color(0xFF232336);

  // Datos de los bares
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

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [neonBlue, neonPink],
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
                      children: [
                        const CircleAvatar(
                          radius: 36,
                          backgroundImage: AssetImage('assets/perfil.JPG'),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '¡Hola, Andres!',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                color: neonPink.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'andres@gmail.com',
                          style: TextStyle(
                            color: neonBlue,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: neonBlue.withOpacity(0.7),
                              ),
                            ],
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
                    leading: Icon(Icons.person, color: neonPink, size: 28),
                    title: const Text('Perfil', style: TextStyle(fontSize: 18, color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.category, color: neonBlue, size: 28),
                    title: const Text('Categorías', style: TextStyle(fontSize: 18, color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.book_online, color: neonGreen, size: 28),
                    title: const Text('Reservas', style: TextStyle(fontSize: 18, color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.settings, color: neonPurple, size: 28),
                    title: const Text('Ajustes', style: TextStyle(fontSize: 18, color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [neonBlue, neonPink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 18,
                            color: neonPink.withOpacity(0.7),
                          ),
                          Shadow(
                            blurRadius: 32,
                            color: neonBlue.withOpacity(0.5),
                          ),
                        ],
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
            toolbarHeight: 70,
          ),
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
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.saturation,
                        ),
                        child: Image.asset(
                          bar['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
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
                                      color: neonPink.withOpacity(0.7),
                                    ),
                                    Shadow(
                                      blurRadius: 32,
                                      color: neonBlue.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bar['desc'],
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: neonBlue.withOpacity(0.4),
                                    ),
                                  ],
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
    );
  }
}

class BarCard extends StatefulWidget {
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
  State<BarCard> createState() => _BarCardState();
}

class _BarCardState extends State<BarCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final neonBlue = const Color(0xFF00F6FF);
    final neonPink = const Color(0xFFFF00A6);
    final neonPurple = const Color(0xFF8A2BE2);
    final neonGreen = const Color(0xFF39FF14);
    final cardBg = const Color(0xFF232336);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(28),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: neonPink.withOpacity(0.5),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: neonBlue.withOpacity(0.3),
                    blurRadius: 48,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.saturation,
                ),
                child: Image.asset(
                  widget.image,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  color: _hovered ? neonPink.withOpacity(0.15) : null,
                  colorBlendMode: BlendMode.screen,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: neonBlue.withOpacity(0.7),
                          ),
                          Shadow(
                            blurRadius: 24,
                            color: neonPink.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: neonPink),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.address,
                            style: const TextStyle(fontSize: 15, color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.access_time, size: 18, color: neonBlue),
                        const SizedBox(width: 4),
                        Text(
                          widget.distance,
                          style: const TextStyle(fontSize: 15, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: widget.tags.map((tag) {
                        Color borderColor = neonPink;
                        if (tag.toLowerCase().contains('electrónica')) borderColor = neonBlue;
                        if (tag.toLowerCase().contains('salsa')) borderColor = neonGreen;
                        if (tag.toLowerCase().contains('reggaetón')) borderColor = neonPink;
                        if (tag.toLowerCase().contains('techno')) borderColor = neonPurple;
                        return Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.transparent,
                          shape: StadiumBorder(
                            side: BorderSide(color: borderColor, width: 2),
                          ),
                          side: BorderSide(color: borderColor, width: 2),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
