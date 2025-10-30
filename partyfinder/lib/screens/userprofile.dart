import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgBlue = Color(0xFF1B263B);
    const Color midBlue = Color(0xFF185ADB);
    const Color darkBlue = Color(0xFF0A2342);
    const Color accentYellow = Color(0xFFFFD93D);

    return Scaffold(
      backgroundColor: bgBlue,
      appBar: AppBar(
        backgroundColor: midBlue,
        title: const Text('Mi Perfil'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              // 📸 Foto de perfil
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('assets/perfil.JPG'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Andrés García',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '@andresgarcia',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // 📊 Estadísticas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _ProfileStat(title: 'Amigos', value: '124'),
                  _ProfileStat(title: 'Favoritos', value: '32'),
                  _ProfileStat(title: 'Reseñas', value: '18'),
                ],
              ),
              const SizedBox(height: 30),

              // 📝 Bio
              Container(
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Amante de la música latina y los ambientes con buena vibra. '
                  'Me encanta descubrir nuevos bares y compartir momentos con amigos.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // 🗂️ Sección de publicaciones o actividad
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mis actividades recientes',
                  style: TextStyle(
                    color: accentYellow,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _ActivityCard(
                image: 'assets/bar1.jpg',
                title: 'Dakiti Club',
                description: 'Una noche inolvidable con música crossover 🔥',
              ),
              const SizedBox(height: 12),
              _ActivityCard(
                image: 'assets/bar3.jpg',
                title: 'Clandestino',
                description: 'La mejor salsa de la ciudad 💃',
              ),
              const SizedBox(height: 12),
              _ActivityCard(
                image: 'assets/bar5.jpg',
                title: 'Presea Bar',
                description: 'Techno vibes y buena compañía 🎧',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String value;
  const _ProfileStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const _ActivityCard({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF222B45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(image, width: 90, height: 90, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
