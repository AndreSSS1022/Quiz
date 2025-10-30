import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Vista'),
      ),
      body: const Center(
        child: Text('Aquí va el contenido de la nueva vista.'),
      ),
    );
  }
}