import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/home_grid.dart';
import '../provider/theme_provider.dart' as my_theme;

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final themeMode = ref.watch(my_theme.themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          IconButton(
            icon: Icon(
              themeMode == my_theme.AppThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Alternar tema',
            onPressed:
                () => ref.read(my_theme.themeProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ModulosGrid(), // Agora com comportamento de Wrap
          ),
          Text(
            'Bem-vindo!',
            style: TextStyle(
              fontSize: 24,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          if (user != null)
            Text(
              'Logado como:\n${user.email}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
