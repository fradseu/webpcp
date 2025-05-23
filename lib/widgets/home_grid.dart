import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lts_pcp_web/provider/user_modulos.dart';

class ModulosGrid extends ConsumerWidget {
  const ModulosGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulosAsync = ref.watch(modulosProvider);

    return modulosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Erro: $err')),
      data: (modulos) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: modulos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final modulo = modulos[index];
            final nome = modulo['nome'] ?? 'Sem nome';
            final iconName = modulo['icon'] ?? 'help_outline';
            final route = modulo['route'] ?? '/';

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, route);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getMaterialIconByName(iconName),
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nome.toString().toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getMaterialIconByName(String iconName) {
    // Um map simples para interpretar nomes comuns para Material Icons.
    const iconMap = {
      'shelves': Icons.shelves,
      'factory': Icons.factory,
      'settings': Icons.settings,
      'dashboard': Icons.dashboard,
      'inventory': Icons.inventory,
      'person': Icons.person_outline,
      'help_outline': Icons.help_outline,
      // Adicione mais ícones conforme sua necessidade
    };

    return iconMap[iconName] ?? Icons.help_outline;
  }
}
