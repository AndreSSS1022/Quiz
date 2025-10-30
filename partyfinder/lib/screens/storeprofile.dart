import 'package:flutter/material.dart';

class StoreProfile extends StatelessWidget {
  const StoreProfile({super.key});

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
        title: const Text('Perfil del Establecimiento'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/bar1.jpg'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Dakiti Club',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Carrera 22 #52, Bogotá',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Un club con ambiente crossover y la mejor música para bailar toda la noche. '
                  'Contamos con DJs internacionales y eventos temáticos cada semana.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // ⭐ Reseñas promedio
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star, color: accentYellow, size: 28),
                  Icon(Icons.star, color: accentYellow, size: 28),
                  Icon(Icons.star, color: accentYellow, size: 28),
                  Icon(Icons.star_half, color: accentYellow, size: 28),
                  Icon(Icons.star_border, color: accentYellow, size: 28),
                ],
              ),
              const SizedBox(height: 10),
              const Text('4.3 de 5 (245 reseñas)',
                  style: TextStyle(color: Colors.white70)),

              const SizedBox(height: 30),

              // 📸 Galería de fotos
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Galería de eventos',
                  style: TextStyle(
                    color: accentYellow,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _GalleryItem('assets/bar2.jpg'),
                    _GalleryItem('assets/bar3.jpg'),
                    _GalleryItem('assets/bar4.jpg'),
                    _GalleryItem('assets/bar5.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 📅 Próximos eventos
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Próximos eventos',
                  style: TextStyle(
                    color: accentYellow,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _EventCard(
                title: 'Fiesta de Halloween 🎃',
                date: '31 Octubre 2025',
                desc: '¡Ven con tu mejor disfraz! Premios y DJs invitados.',
              ),
              const SizedBox(height: 12),
              _EventCard(
                title: 'Noche de Reggaetón 💃',
                date: '7 Noviembre 2025',
                desc: 'Lo mejor del género con DJ Leo Vargas.',
              ),
              const SizedBox(height: 12),
              _EventCard(
                title: 'After Party Techno 🎧',
                date: '14 Noviembre 2025',
                desc: 'Ambiente underground con luces y beats intensos.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryItem extends StatelessWidget {
  final String image;
  const _GalleryItem(this.image);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(image, width: 150, fit: BoxFit.cover),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String desc;
  const _EventCard({
    required this.title,
    required this.date,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF222B45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
      ),
    );
  }
}
