import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class Mapa extends StatefulWidget {
  final bool embed; // si true muestra solo el mapa (sin AppBar ni bottom bar)
  const Mapa({super.key, this.embed = false});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  double _rotationRadians = 0.0;

  StreamSubscription<MagnetometerEvent>? _magSub;
  StreamSubscription<Position>? _posSub;
  Position? _currentPosition;

  final MapController _mapController = MapController();
  double _currentZoom = 16.0; // mantener zoom actual para mover el mapa sin errores

  @override
  void initState() {
    super.initState();
    // Siempre iniciar magnetómetro y ubicación al abrir el mapa
    _startMagnetometer();
    _startLocationHandling();
  }

  @override
  void dispose() {
    _cancelMagSubscription();
    _cancelPosSubscription();
    // NO llamar a _mapController.dispose() -> flutter_map MapController no tiene dispose()
    super.dispose();
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
    if (!mounted) return;
    
    _currentPosition = p;
    final latlng = LatLng(p.latitude, p.longitude);
    
    setState(() {});
    
    // Mover mapa suavemente a la ubicación actual
    try {
      _mapController.move(latlng, _currentZoom);
    } catch (_) {
      // Ignorar errores si el controlador no está listo
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
    );
  }


  Widget _buildMap() {
    // Usar la ubicación actual del GPS si está disponible, sino un fallback
    final center = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : LatLng(4.6097, -74.0817); // Bogotá como fallback

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: _currentZoom,
        initialRotation: _rotationRadians,
        onPositionChanged: (pos, hasGesture) {
          final z = pos.zoom;
          if (mounted) {
            setState(() => _currentZoom = z);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.partyfinder.app',
        ),
        if (_currentPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                width: 48,
                height: 48,
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