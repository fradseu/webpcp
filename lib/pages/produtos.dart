import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lts_pcp_web/widgets/home_grid.dart';

class ProdutosPage extends StatelessWidget {
  const ProdutosPage({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/login',
      ); // ajuste a rota conforme seu app
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color.fromARGB(255, 69, 43, 94),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: ModulosGrid()),
            const Text('Bem-vindo!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            if (user != null)
              Text(
                'Logado como:\n${user.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 69, 43, 94),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
