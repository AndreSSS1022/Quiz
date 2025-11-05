import 'package:flutter/material.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  // 🎨 Paleta de colores (variables globales del tema)
  final Color primaryColor = const Color(0xFF00C2FF);
  final Color secondaryColor = const Color(0xFFB026FF);
  final Color backgroundColor = const Color(0xFF0A0A23);
  final Color cardColor = const Color(0xFF14143A);
  final Color textColor = Colors.white;
  final Color accentColor = const Color(0xFFFF4081);

  // 📝 Lista simulada de reservas
  List<Map<String, String>> reservas = [];

  // 🧾 Controladores del formulario
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

  // ➕ Función para agregar una nueva reserva
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
        const SnackBar(content: Text('🎉 ¡Reserva agregada con éxito!')),
      );
    }
  }

  // 🪩 Diálogo para crear nueva reserva
  void _mostrarDialogoNuevaReserva() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Nueva Reserva', style: TextStyle(color: primaryColor)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_eventoController, 'Evento'),
              _buildTextField(_fechaController, 'Fecha (YYYY-MM-DD)'),
              _buildTextField(_lugarController, 'Lugar'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _agregarReserva,
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor, width: 2),
          ),
        ),
        validator: (v) =>
            v == null || v.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _mostrarDialogoNuevaReserva,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: reservas.isEmpty
          ? Center(
              child: Text(
                'No tienes reservas aún 🕺',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                final r = reservas[index];
                return _buildReservaCard(r, index);
              },
            ),
    );
  }

  // 💡 Tarjeta personalizada de reserva
  Widget _buildReservaCard(Map<String, String> reserva, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardColor, cardColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.music_note_rounded, color: accentColor, size: 30),
        title: Text(
          reserva['evento']!,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${reserva['fecha']}\n ${reserva['lugar']}',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            setState(() => reservas.removeAt(index));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reserva eliminada: ${reserva['evento']}')),
            );
          },
        ),
      ),
    );
  }
}

