

import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with SingleTickerProviderStateMixin {
  final Color darkBlue = const Color(0xFF0A2342);
  final Color midBlue = const Color(0xFF185ADB);
  final Color bgBlue = const Color(0xFF1B263B);
  final Color cardBlue = const Color(0xFF222B45);
  final Color accentYellow = const Color(0xFFFFD93D);

  late TabController _tabController;

  // Simulación de datos de red social
  final List<Map<String, dynamic>> userPosts = [
    {
      'club': 'Dakiti Club',
      'image': 'assets/bar1.jpg',
      'date': 'Hace 2 días',
      'caption': '¡Noche increíble! 🔥 La mejor rumba',
      'likes': 45,
      'comments': 12,
    },
    {
      'club': 'Theatron',
      'image': 'assets/bar2.jpg',
      'date': 'Hace 1 semana',
      'caption': 'Experiencia única en el club más grande 🎉',
      'likes': 78,
      'comments': 23,
    },
    {
      'club': 'Clandestino',
      'image': 'assets/bar3.jpg',
      'date': 'Hace 2 semanas',
      'caption': 'Salsa y sabor 💃🕺',
      'likes': 56,
      'comments': 18,
    },
  ];

  final List<Map<String, String>> friends = [
    {'name': 'María López', 'image': 'assets/perfil.JPG', 'mutual': '12'},
    {'name': 'Carlos Ruiz', 'image': 'assets/perfil.JPG', 'mutual': '8'},
    {'name': 'Ana García', 'image': 'assets/perfil.JPG', 'mutual': '15'},
    {'name': 'Luis Torres', 'image': 'assets/perfil.JPG', 'mutual': '6'},
  ];

  final List<Map<String, dynamic>> achievements = [
    {'icon': Icons.celebration, 'title': 'Party Animal', 'desc': '10+ fiestas'},
    {'icon': Icons.star, 'title': 'VIP Member', 'desc': 'Miembro desde 2023'},
    {'icon': Icons.favorite, 'title': 'Social Butterfly', 'desc': '50+ amigos'},
    {'icon': Icons.reviews, 'title': 'Top Reviewer', 'desc': '20+ reseñas'},
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
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [midBlue, darkBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: const AssetImage('assets/perfil.JPG'),
                            backgroundColor: Colors.white,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: accentYellow,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Andres Martinez',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '@andres_party',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatColumn('24', 'Posts'),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white24,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          _buildStatColumn('156', 'Amigos'),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white24,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          _buildStatColumn('89', 'Siguiendo'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: accentYellow,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                tabs: const [
                  Tab(icon: Icon(Icons.grid_on), text: 'Posts'),
                  Tab(icon: Icon(Icons.people), text: 'Amigos'),
                  Tab(icon: Icon(Icons.info), text: 'Info'),
                  Tab(icon: Icon(Icons.emoji_events), text: 'Logros'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPostsTab(),
            _buildFriendsTab(),
            _buildInfoTab(),
            _buildAchievementsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: accentYellow,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // TAB 1: Posts (Red Social)
  Widget _buildPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        final post = userPosts[index];
        return Card(
          elevation: 6,
          color: cardBlue,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del post
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: const AssetImage('assets/perfil.JPG'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Andres Martinez',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'en ${post['club']} • ${post['date']}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert, color: Colors.white54),
                  ],
                ),
              ),
              // Imagen del post
              ClipRRect(
                child: Image.asset(
                  post['image'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              // Caption y acciones
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
                          onPressed: () {},
                        ),
                        Text('${post['likes']}', style: const TextStyle(color: Colors.white)),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                          onPressed: () {},
                        ),
                        Text('${post['comments']}', style: const TextStyle(color: Colors.white)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Text(
                      post['caption'],
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // TAB 2: Amigos
  Widget _buildFriendsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Card(
          elevation: 4,
          color: cardBlue,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(friend['image']!),
            ),
            title: Text(
              friend['name']!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '${friend['mutual']} amigos en común',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: midBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Ver Perfil', style: TextStyle(fontSize: 12)),
            ),
          ),
        );
      },
    );
  }

  // TAB 3: Información
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
                  'Información Personal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: midBlue),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.email, 'Email', 'andres@ejemplo.com'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.phone, 'Teléfono', '+57 300 123 4567'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.location_city, 'Ciudad', 'Bogotá, Colombia'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.cake, 'Cumpleaños', '15 de Marzo, 1995'),
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
                  'Géneros Favoritos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: midBlue),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildGenreChip('Reggaetón', midBlue),
                    _buildGenreChip('Electrónica', darkBlue),
                    _buildGenreChip('Salsa', accentYellow),
                    _buildGenreChip('Pop', midBlue),
                    _buildGenreChip('Techno', darkBlue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TAB 4: Logros
  Widget _buildAchievementsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Card(
          elevation: 6,
          color: cardBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accentYellow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(achievement['icon'], size: 40, color: darkBlue),
                ),
                const SizedBox(height: 12),
                Text(
                  achievement['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: midBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement['desc'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 22, color: accentYellow),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.white54)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenreChip(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
    );
  }
}


