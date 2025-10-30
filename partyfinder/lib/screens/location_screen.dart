import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // 1. Importa el paquete

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  String? _error;

  // 2. Esta es la función clave para obtener la ubicación
  Future<void> _getCurrentLocation() async {
    // Muestra el círculo de carga y limpia errores previos
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // a. Primero, comprueba si los servicios de ubicación están activados
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Los servicios de ubicación están desactivados.');
      }

      // b. Luego, comprueba y solicita los permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Los permisos de ubicación fueron denegados.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Si el usuario denegó permanentemente los permisos
        throw Exception(
            'Los permisos de ubicación están permanentemente denegados. No podemos solicitar la ubicación.');
      }

      // c. Si todo está bien, obtenemos la posición actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // d. Actualizamos la pantalla con los datos obtenidos
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isLoading = false; // Ocultamos el círculo de carga
      });
    } catch (e) {
      // e. Si algo falla, guardamos el mensaje de error
      setState(() {
        _error = e.toString().replaceAll("Exception: ", ""); // Muestra un error más limpio
        _isLoading = false; // Ocultamos el círculo de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Ubicación'),
        backgroundColor: const Color(0xFF0A2342), // Usando tu color darkBlue
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined,
                size: 100, color: Color(0xFF185ADB)), // Usando tu color midBlue
            const SizedBox(height: 20),
            const Text(
              'Coordenadas Actuales',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Mostrar un indicador de carga mientras se obtiene la ubicación
            if (_isLoading)
              const CircularProgressIndicator()
            // Mostrar la ubicación si la tenemos
            else if (_latitude != null && _longitude != null)
              Text(
                'Latitud: $_latitude\nLongitud: $_longitude',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              )
            // Mostrar un error si ocurrió uno
            else if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Error: $_error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              // Mensaje inicial antes de pulsar el botón
              else
                const Text(
                  'Presiona el botón para obtener tu ubicación',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Obtener Ubicación'),
              onPressed:
              _isLoading ? null : _getCurrentLocation, // 3. Llama a la nueva función
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFFFFD93D), // Usando tu color accentYellow
                foregroundColor: Colors.black,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
