import 'dart:io';

import 'package:flutter/material.dart';
import '../utils/session_manager.dart';

class UserAvatar extends StatelessWidget {
  final double? radius;
  final double? size;
  final VoidCallback? onTap;
  final String? src; // puede ser ruta de archivo local o asset (p.ej. 'assets/perfil.JPG')
  final String? initials; // si no hay imagen, mostrar iniciales
  final bool useSessionIfNull; // si true y src==null, intenta cargar la imagen de SessionManager

  const UserAvatar({super.key, this.radius, this.size, this.onTap, this.src, this.initials, this.useSessionIfNull = true});

  @override
  Widget build(BuildContext context) {
    final double displayRadius = radius ?? (size != null ? size! / 2 : 24);

    Widget avatarProviderFromPath(String? path) {
      if (path != null && path.isNotEmpty) {
        try {
          if (File(path).existsSync()) {
            return CircleAvatar(radius: displayRadius, backgroundImage: FileImage(File(path)));
          }
        } catch (_) {}

        if (path.startsWith('assets/')) {
          return CircleAvatar(radius: displayRadius, backgroundImage: AssetImage(path));
        }
      }

      if (initials != null && initials!.isNotEmpty) {
        return CircleAvatar(
          radius: displayRadius,
          backgroundColor: const Color(0xFF222B45),
          child: Text(initials!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: displayRadius * 0.8)),
        );
      }

      return CircleAvatar(
        radius: displayRadius,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: (displayRadius * 1.4), color: const Color(0xFF0A2342)),
      );
    }

    if (src != null) {
      return GestureDetector(onTap: onTap, child: avatarProviderFromPath(src));
    }

    if (!useSessionIfNull) {
      return GestureDetector(onTap: onTap, child: avatarProviderFromPath(null));
    }

    return FutureBuilder<String?>(
      future: SessionManager.getImagePath(),
      builder: (context, snap) {
        final path = snap.data;
        return GestureDetector(onTap: onTap, child: avatarProviderFromPath(path));
      },
    );
  }
}
