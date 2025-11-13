import 'package:flutter/material.dart';
import '../widgets/user_avatar.dart';

class StoreProfile extends StatefulWidget {
  final String name;
  final String address;
  final String image;
  final List<String> tags;
  final String desc;

  const StoreProfile({
    super.key,
    this.name = 'Dakiti Club',
    this.address = 'Carrera 22 #52, Bogotá',
    this.image = 'assets/bar1.jpg',
    this.tags = const ['Reggaetón', 'Crossover'],
    this.desc = 'Un club con ambiente crossover y la mejor música para bailar toda la noche.',
  });

  @override
  State<StoreProfile> createState() => _StoreProfileState();
}

class _StoreProfileState extends State<StoreProfile> with SingleTickerProviderStateMixin {
  final Color darkBlue = const Color(0xFF0A2342);
  final Color midBlue = const Color(0xFF185ADB);
  final Color bgBlue = const Color(0xFF1B263B);
  final Color cardBlue = const Color(0xFF222B45);
  final Color accentYellow = const Color(0xFFFFD93D);

  bool isFavorite = false;
  late TabController _tabController;

  final List<String> galleryImages = [
    'assets/bar1.jpg',
    'assets/bar2.jpg',
    'assets/bar3.jpg',
    'assets/bar4.jpg',
    'assets/bar5.jpg',
    'assets/bar1.jpg',
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      'user': 'María López',
      'rating': 5,
      'date': 'Hace 3 días',
      'comment': '¡Increíble ambiente! La música estuvo espectacular y el servicio de primera.',
      'image': 'assets/perfil.JPG',
    },
    {
      'user': 'Carlos Ruiz',
      'rating': 4,
      'date': 'Hace 1 semana',
      'comment': 'Muy buen lugar para pasar el fin de semana. Recomendado 100%',
      'image': 'assets/perfil.JPG',
    },
    {
      'user': 'Ana García',
      'rating': 5,
      'date': 'Hace 2 semanas',
      'comment': 'La mejor fiesta de mi vida. Volveré sin duda 🎉',
      'image': 'assets/perfil.JPG',
    },
    {
      'user': 'Luis Torres',
      'rating': 4,
      'date': 'Hace 3 semanas',
      'comment': 'Excelente música y buen ambiente. Solo mejoraría los precios de bebidas.',
      'image': 'assets/perfil.JPG',
    },
  ];

  final List<Map<String, dynamic>> upcomingEvents = [
    {
      'name': 'Noche de Reggaetón',
      'date': 'Viernes 8 Nov',
      'time': '10:00 PM',
      'price': '\$50.000',
      'dj': 'DJ Fuego',
    },
    {
      'name': 'Saturday Party',
      'date': 'Sábado 9 Nov',
      'time': '11:00 PM',
      'price': '\$60.000',
      'dj': 'DJ Thunder',
    },
    {
      'name': 'Crossover Night',
      'date': 'Domingo 10 Nov',
      'time': '9:00 PM',
      'price': '\$45.000',
      'dj': 'DJ Mix',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: darkBlue,
                leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha((0.5 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((0.5 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((0.5 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Compartir establecimiento')),
                      );
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(widget.image, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                                  Colors.black.withAlpha((0.7 * 255).round()),
                                  Colors.transparent,
                                  Colors.black.withAlpha((0.8 * 255).round()),
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 70,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: accentYellow, size: 22),
                              const SizedBox(width: 4),
                              const Text(
                                '4.8',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '(450 reseñas)',
                                style: TextStyle(fontSize: 15, color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: accentYellow,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                isScrollable: false,
                labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(icon: Icon(Icons.info_outline, size: 22), text: 'Info'),
                  Tab(icon: Icon(Icons.event, size: 22), text: 'Eventos'),
                  Tab(icon: Icon(Icons.photo_library, size: 22), text: 'Galería'),
                  Tab(icon: Icon(Icons.rate_review, size: 22), text: 'Reseñas'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildInfoTab(),
            _buildEventsTab(),
            _buildGalleryTab(),
            _buildReviewsTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBlue,
            boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.3 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showReservationBottomSheet(context);
                  },
                  icon: const Icon(Icons.calendar_today, size: 20),
                  label: const Text(
                    'Reservar Mesa',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentYellow,
                    foregroundColor: darkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Llamando al establecimiento...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: midBlue,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Icon(Icons.phone, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 1: Información
  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 6,
          color: cardBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: midBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.desc,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoItem(Icons.location_on, 'Dirección', widget.address),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoItem(Icons.access_time, 'Horario', 'Jue-Sáb: 10PM - 4AM'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoItem(Icons.phone, 'Teléfono', '+57 1 234 5678'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoItem(Icons.payments, 'Entrada', '\$30.000 - \$60.000'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 6,
          color: cardBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Géneros Musicales',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: midBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.tags.map((tag) {
                    Color chipColor = midBlue;
                    if (tag.toLowerCase().contains('electrónica')) chipColor = darkBlue;
                    if (tag.toLowerCase().contains('salsa')) chipColor = accentYellow;
                    if (tag.toLowerCase().contains('techno')) chipColor = darkBlue;
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: chipColor,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 6,
          color: cardBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Servicios',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: midBlue,
                  ),
                ),
                const SizedBox(height: 10),
                _buildServiceItem(Icons.wifi, 'WiFi Gratis'),
                _buildServiceItem(Icons.local_parking, 'Parqueadero'),
                _buildServiceItem(Icons.security, 'Seguridad 24/7'),
                _buildServiceItem(Icons.restaurant, 'Servicio de Bar'),
                _buildServiceItem(Icons.smoke_free, 'Zona Fumadores'),
                _buildServiceItem(Icons.wheelchair_pickup, 'Accesibilidad'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TAB 2: Eventos
  Widget _buildEventsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingEvents.length,
      itemBuilder: (context, index) {
        final event = upcomingEvents[index];
        return Card(
          elevation: 6,
          color: cardBlue,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 420;
                final dateBox = Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [midBlue, darkBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        event['date'].split(' ')[0],
                        style: TextStyle(
                          color: accentYellow,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        event['date'].split(' ')[1],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        event['date'].split(' ')[2],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );

                final details = Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: midBlue,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '🎧 ${event['dj']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: accentYellow),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              event['time'],
                              style: const TextStyle(color: Colors.white70),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.attach_money, size: 14, color: accentYellow),
                          Flexible(
                            child: Text(
                              event['price'],
                              style: const TextStyle(color: Colors.white70),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                final reserveButton = ElevatedButton(
                  onPressed: () {
                    _showReservationBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentYellow,
                    foregroundColor: darkBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reservar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [dateBox, const SizedBox(width: 12), Expanded(child: details.child)]),
                      const SizedBox(height: 12),
                      Align(alignment: Alignment.centerRight, child: reserveButton),
                    ],
                  );
                }

                return Row(
                  children: [
                    dateBox,
                    const SizedBox(width: 16),
                    details,
                    reserveButton,
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // TAB 3: Galería
  Widget _buildGalleryTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: galleryImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        galleryImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentYellow,
                        foregroundColor: darkBlue,
                      ),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              galleryImages[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  // TAB 4: Reseñas
  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 6,
          color: cardBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '4.8',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: accentYellow,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(Icons.star, color: accentYellow, size: 20),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '450 reseñas',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingBar(5, 280),
                    _buildRatingBar(4, 120),
                    _buildRatingBar(3, 30),
                    _buildRatingBar(2, 15),
                    _buildRatingBar(1, 5),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...reviews.map((review) => Card(
              elevation: 4,
              color: cardBlue,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UserAvatar(radius: 25, src: review['image']),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['user'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                review['date'],
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < review['rating'] ? Icons.star : Icons.star_border,
                              color: accentYellow,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      review['comment'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildRatingBar(int stars, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Icon(Icons.star, color: accentYellow, size: 14),
          const SizedBox(width: 8),
          Container(
            width: 80,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: count / 280,
              child: Container(
                decoration: BoxDecoration(
                  color: accentYellow,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: accentYellow, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.white54),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: midBlue, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _showReservationBottomSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController peopleController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBlue,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Reservar Mesa',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: midBlue,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nombre completo',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: bgBlue,
                    prefixIcon: Icon(Icons.person, color: midBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: bgBlue,
                    prefixIcon: Icon(Icons.phone, color: midBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: peopleController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Número de personas',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: bgBlue,
                    prefixIcon: Icon(Icons.people, color: midBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('¡Reserva confirmada! Te contactaremos pronto.'),
                          backgroundColor: midBlue,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentYellow,
                      foregroundColor: darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirmar Reserva',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}




