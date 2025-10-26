import 'package:flutter/material.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _NewViewState();
}

class _NewViewState extends State<Bookings> {
  final Color midBlue = const Color(0xFF185ADB);

  // Lista simulada de reservas
  List<Map<String, String>> reservas = [
    {
      'evento': 'Fiesta electrónica',
      'fecha': '2025-11-01',
      'lugar': 'Zona T - Bogotá',
    },
    {
      'evento': 'Concierto de Rock',
      'fecha': '2025-12-12',
      'lugar': 'Movistar Arena',
    },
  ];

  // Controladores del formulario
  final _formKey = GlobalKey<FormState>();
  final _eventoController = TextEditingController();
  final _fechaController = TextEditingController();
  final _lugarController = TextEditingController();

  @override
  void dispose() {
    _eventoController.dispose();
    _fechaController.dispose();
    _lugarController.dispose();
    super.dispose();
  }

  // Función para agregar una nueva reserva
  void _agregarReserva() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        reservas.add({
          'evento': _eventoController.text,
          'fecha': _fechaController.text,
          'lugar': _lugarController.text,
        });
      });
      Navigator.pop(context);
      _eventoController.clear();
      _fechaController.clear();
      _lugarController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva agregada con éxito')),
      );
    }
  }

  // Diálogo para crear nueva reserva
  void _mostrarDialogoNuevaReserva() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text('Nueva Reserva'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _eventoController,
                decoration: const InputDecoration(labelText: 'Evento'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _lugarController,
                decoration: const InputDecoration(labelText: 'Lugar'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: midBlue),
            onPressed: _agregarReserva,
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        backgroundColor: midBlue,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF1B263B),

      // 🔘 Botón flotante para nueva reserva
      floatingActionButton: FloatingActionButton(
        backgroundColor: midBlue,
        onPressed: _mostrarDialogoNuevaReserva,
        child: const Icon(Icons.add),
      ),

      // 📋 Lista de reservas
      body: reservas.isEmpty
          ? const Center(
              child: Text('No tienes reservas aún',
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                final r = reservas[index];
                return Card(
                  color: const Color(0xFF222B45),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.white),
                    title: Text(r['evento']!,
                        style: const TextStyle(fontSize: 18, color: Colors.white)),
                    subtitle: Text(
                      '📅 ${r['fecha']}\n📍 ${r['lugar']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() => reservas.removeAt(index));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Reserva eliminada: ${r['evento']}')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

