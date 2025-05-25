import 'package:flutter/material.dart';

class BtnNovoProduto extends StatelessWidget {
  const BtnNovoProduto({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, size: 16), // Ícone à esquerda
      label: const Text(
        'Novo',
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
      ),
    );
  }
}
