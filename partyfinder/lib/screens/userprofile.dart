

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/session_manager.dart';
import '../widgets/user_avatar.dart';

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
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _birthDate;
  String? _imagePath;

  String get _displayName {
    if ((_firstName ?? '').isEmpty && (_lastName ?? '').isEmpty) return 'Andres Martinez';
    return '${_firstName ?? ''}${(_firstName != null && _firstName!.isNotEmpty && _lastName != null && _lastName!.isNotEmpty) ? ' ' : ''}${_lastName ?? ''}'.trim();
  }

  String get _handle {
    if ((_firstName ?? '').isEmpty) return '@andres_party';
    final handle = '${_firstName!.toLowerCase()}${_lastName != null && _lastName!.isNotEmpty ? '_${_lastName!.toLowerCase()}' : ''}';
    return '@${handle.replaceAll(' ', '')}';
  }

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
    {'name': 'María López', 'image': '', 'mutual': '12'},
    {'name': 'Carlos Ruiz', 'image': '', 'mutual': '8'},
    {'name': 'Ana García', 'image': '', 'mutual': '15'},
    {'name': 'Luis Torres', 'image': '', 'mutual': '6'},
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
    _loadNames();
  }

  Future<void> _loadNames() async {
    final f = await SessionManager.getFirstName();
    final l = await SessionManager.getLastName();
    final e = await SessionManager.getEmail();
    final b = await SessionManager.getBirthDate();
    final img = await SessionManager.getImagePath();
    if (!mounted) return;
    setState(() {
      _firstName = f;
      _lastName = l;
      _email = e;
      _birthDate = b;
      _imagePath = img;
    });
  }

  Future<void> _pickImage() async {
    // Pedir permiso según plataforma y versiones (Android 13+ usa READ_MEDIA_IMAGES)
    if (!mounted) return;
    PermissionStatus statusPhotos = PermissionStatus.denied;
    PermissionStatus statusStorage = PermissionStatus.denied;

    try {
      if (Platform.isAndroid) {
        // Pedimos ambos por compatibilidad: storage (pre-Android13) y photos (Android13+)
        statusPhotos = await Permission.photos.request();
        statusStorage = await Permission.storage.request();
      } else if (Platform.isIOS) {
        statusPhotos = await Permission.photos.request();
      } else {
        // otras plataformas: intentar photos
        statusPhotos = await Permission.photos.request();
      }
    } catch (e) {
      // en caso de que alguna permission no exista en la plataforma, ignoramos
    }

    final granted = (statusPhotos.isGranted) || (statusStorage.isGranted);
    if (!granted) {
      // Si están denegados permanentemente sugerimos ir a ajustes
      final permanentlyDenied = (statusPhotos.isPermanentlyDenied) || (statusStorage.isPermanentlyDenied);
      if (permanentlyDenied) {
        final open = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permiso requerido'),
            content: const Text('El permiso para acceder a la galería fue denegado permanentemente. ¿Quieres abrir los ajustes de la aplicación para activarlo?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Abrir ajustes')),
            ],
          ),
        );
        if (open == true) await openAppSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Se necesita permiso para acceder a la galería')));
      }
      return;
    }

    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (picked != null) {
      await SessionManager.saveImagePath(picked.path);
      if (!mounted) return;
      setState(() {
        _imagePath = picked.path;
      });
    }
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
              expandedHeight: 280,
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
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Stack(
                          children: [
                            UserAvatar(radius: 45, onTap: _pickImage, src: _imagePath),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: accentYellow,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _handle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatColumn('24', 'Posts'),
                            Container(
                              height: 28,
                              width: 1,
                              color: Colors.white24,
                              margin: const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            _buildStatColumn('156', 'Amigos'),
                            Container(
                              height: 28,
                              width: 1,
                              color: Colors.white24,
                              margin: const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            _buildStatColumn('89', 'Siguiendo'),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: accentYellow,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on, size: 20), text: 'Posts'),
                    Tab(icon: Icon(Icons.people, size: 20), text: 'Amigos'),
                    Tab(icon: Icon(Icons.info, size: 20), text: 'Info'),
                    Tab(icon: Icon(Icons.emoji_events, size: 20), text: 'Logros'),
                  ],
                ),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: accentYellow,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
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
                    UserAvatar(radius: 20, src: _imagePath),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayName,
                            style: const TextStyle(
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
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              // Caption y acciones
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 360;
                        final actionsRow = Row(
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
                            if (!isNarrow) const Spacer(),
                            if (!isNarrow)
                              IconButton(
                                icon: const Icon(Icons.share, color: Colors.white),
                                onPressed: () {},
                              ),
                          ],
                        );

                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              actionsRow,
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.share, color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          );
                        }

                        return actionsRow;
                      },
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
            leading: Builder(builder: (context) {
              final name = friend['name'] ?? '';
              final parts = name.split(' ');
              String initials = '';
              for (var p in parts) {
                if (p.isNotEmpty) initials += p[0];
                if (initials.length >= 2) break;
              }
              initials = initials.toUpperCase();
              return UserAvatar(radius: 30, src: friend['image'] != null && friend['image']!.isNotEmpty ? friend['image'] : null, initials: initials, useSessionIfNull: false);
            }),
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
    // Formatear fecha de nacimiento de YYYY-MM-DD a DD/MM/YYYY
    String formattedBirthDate = 'No disponible';
    if (_birthDate != null && _birthDate!.isNotEmpty) {
      try {
        final parts = _birthDate!.split('-');
        if (parts.length == 3) {
          formattedBirthDate = '${parts[2]}/${parts[1]}/${parts[0]}';
        }
      } catch (_) {
        formattedBirthDate = 'No disponible';
      }
    }

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
                _buildInfoRow(Icons.person, 'Nombre', _firstName ?? 'No disponible'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.person_outline, 'Apellido', _lastName ?? 'No disponible'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.email, 'Email', _email ?? 'No disponible'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.cake, 'Fecha de nacimiento', formattedBirthDate),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.phone, 'Teléfono', '+57 300 123 4567'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.location_city, 'Ciudad', 'Bogotá, Colombia'),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0A2342),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}


