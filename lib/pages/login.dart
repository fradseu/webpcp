import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Aqui depois a gente troca para lógica real de login
            // Por enquanto só printar pra testar
            print('Clicou em login');
          },
          child: const Text('Entrar'),
        ),
      ),
    );
  }
}
