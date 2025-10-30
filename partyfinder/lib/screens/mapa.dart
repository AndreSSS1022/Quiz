import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class Mapa extends StatefulWidget {
  final bool embed; // si true muestra solo el mapa (sin AppBar ni bottom bar)
  const Mapa({Key? key, this.embed = false}) : super(key: key);

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  int _currentIndex = 0;
  double _rotationRadians = 0.0;

  StreamSubscription<MagnetometerEvent>? _magSub;
  StreamSubscription<Position>? _posSub;
  Position? _currentPosition;

  final MapController _mapController = MapController();
  double _currentZoom = 16.0; // mantener zoom actual para mover el mapa sin errores

  @override
  void initState() {
    super.initState();
    // Si el widget se inserta como embed (ej. en un modal deslizante) inicia sensores y ubicación
    if (widget.embed) {
      _startMagnetometer();
      _startLocationHandling();
      // opcional: mostrar el mapa automáticamente (si usas _currentIndex para controlar)
      setState(() => _currentIndex = 1);
    }
  }

  @override
  void dispose() {
    _cancelMagSubscription();
    _cancelPosSubscription();
    // NO llamar a _mapController.dispose() -> flutter_map MapController no tiene dispose()
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    if (index == 1) {
      _startMagnetometer();
      _startLocationHandling();
    } else {
      _cancelMagSubscription();
      _cancelPosSubscription();
    }
  }

  // --- Magnetometer ---
  void _startMagnetometer() {
    _cancelMagSubscription();
    _magSub = magnetometerEvents.listen((MagnetometerEvent e) {
      final rad = (math.atan2(e.y, e.x) + 2 * math.pi) % (2 * math.pi);
      if (mounted) {
        setState(() => _rotationRadians = rad);
      }
    }, onError: (_) {
      // no hacer crash si hay un error de sensor
    });
  }

  void _cancelMagSubscription() {
    _magSub?.cancel();
    _magSub = null;
  }

  // --- Location / Permissions ---
  Future<void> _startLocationHandling() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activa el servicio de ubicación')),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado')),
        );
      }
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      _updatePosition(pos);

      _cancelPosSubscription();
      _posSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5,
        ),
      ).listen((Position p) {
        _updatePosition(p);
      }, onError: (_) {
        // manejar posibles errores del stream
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error obteniendo ubicación: $e')),
        );
      }
    }
  }

  void _cancelPosSubscription() {
    _posSub?.cancel();
    _posSub = null;
  }

  void _updatePosition(Position p) {
    _currentPosition = p;
    final latlng = LatLng(p.latitude, p.longitude);
    if (mounted) {
      setState(() {});
      // Mover mapa suavemente al actualizar posición (usar _currentZoom guardado)
      try {
        _mapController.move(latlng, _currentZoom);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embed) {
      return _buildMap(); // solo el FlutterMap
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: _buildMap(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(child: Text('Pantalla principal'));
  }

  Widget _buildMap() {
    final center = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : LatLng(40.4168, -3.7038); // fallback

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        // flutter_map 8.x usa initialCenter / initialZoom / initialRotation
        initialCenter: center,
        initialZoom: _currentZoom,
        initialRotation: _rotationRadians,
        // actualizar _currentZoom cuando el usuario haga zoom/manualmente cambie la vista
        onPositionChanged: (pos, hasGesture) {
          final z = pos.zoom;
          if (mounted) {
            setState(() => _currentZoom = z);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 48,
              height: 48,
              // en 8.x Marker requiere 'child' en vez de 'builder'
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 36,
              ),
            ),
          ],
        ),
      ],
    );
  }
}