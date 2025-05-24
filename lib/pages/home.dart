import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/theme_provider.dart' as my_theme;
import '../provider/user_modulos.dart';
import '../provider/user_provider.dart';
import '../widgets/home_grid.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Carrega os dados quando o widget é inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });
  }

  // Método para carregar todos os dados necessários
  Future<void> _loadAllData() async {
    await ref.read(userProvider.notifier).fetchUserData();
    // O modulosProvider vai se atualizar automaticamente quando o userProvider mudar
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final modulosAsync = ref.watch(modulosProvider);
    final theme = Theme.of(context);
    final themeMode = ref.watch(my_theme.themeProvider);

    // Mostra um indicador de carregamento enquanto os dados estão sendo buscados
    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          //IconButton(
          //  icon: Icon(
          //    themeMode == my_theme.AppThemeMode.dark
          //        ? Icons.light_mode
          //        : Icons.dark_mode,
          //  ),
          //  tooltip: 'Alternar tema',
          //  onPressed:
          //      () => ref.read(my_theme.themeProvider.notifier).toggleTheme(),
          //),
          _CustomDropdownMenu(),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Grid alinhado no topo e centralizado horizontalmente
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ), // Espaço do topo (opcional)
              child: ModulosGrid(),
            ),
          ),
          // Espaço flexível para empurrar o botão para baixo
          const Spacer(),
        ],
      ),
    );
  }
}

class _CustomDropdownMenu extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CustomDropdownMenu> createState() =>
      _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends ConsumerState<_CustomDropdownMenu> {
  final TextEditingController _controller = TextEditingController(text: '');

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Documentação', 'icon': Icons.description},
    {'title': 'Suporte', 'icon': Icons.live_help},
    {
      'title': 'Modo escuro',
      'icon': Icons.dark_mode,
      'isToggle': true,
      'value': false,
    },
    {'title': 'divider'},
    {'title': 'Meu perfil', 'icon': Icons.person},
    {'title': 'Minhas bases de dados', 'icon': Icons.storage},
    {'title': 'divider'},
    {'title': 'Sair', 'icon': Icons.logout, 'isSpecial': true},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(my_theme.themeProvider);

    return DropdownMenu(
      controller: _controller,
      initialSelection: 'Menu',
      width: 220,
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        isCollapsed: true,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          themeMode == my_theme.AppThemeMode.dark
              ? Colors.grey[900]
              : Colors.white,
        ),
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      leadingIcon: const Icon(Icons.search),
      trailingIcon: const Icon(Icons.arrow_drop_down),
      label: const Text('Menu', style: TextStyle(fontSize: 13)),
      dropdownMenuEntries:
          _menuItems.map((item) {
            if (item['title'] == 'divider') {
              return DropdownMenuEntry(
                value: 'divider',
                enabled: false,
                labelWidget: const Divider(height: 1, thickness: 1),
                label: '',
              );
            }

            return DropdownMenuEntry(
              value: item['title'],
              labelWidget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child:
                    item['isToggle'] == true
                        ? _buildToggleRow(
                          item['title'],
                          item['icon'],
                          item['value'] as bool,
                          (value) {
                            setState(() {
                              item['value'] = value;
                            });
                          },
                        )
                        : _buildMenuItem(
                          item['title'],
                          icon: item['icon'],
                          trailing: item['trailing'],
                          isSpecial: item['isSpecial'] == true,
                        ),
              ),
              label: '',
            );
          }).toList(),
      onSelected: (value) async {
        if (value == 'Sair') {
          try {
            await FirebaseAuth.instance.signOut();

            if (context.mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Erro ao sair: $e')));
          }
        } else if (value != 'divider') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$value selecionado')));
        }
      },
    );
  }

  Widget _buildMenuItem(
    String text, {
    IconData? icon,
    String? trailing,
    bool isSpecial = false,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: isSpecial ? Colors.red : null),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isSpecial ? Colors.red : null,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildToggleRow(
    String text,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final isDark =
        ref.watch(my_theme.themeProvider) == my_theme.AppThemeMode.dark;

    return Row(
      children: [
        Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 18),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        GestureDetector(
          onTap: () {
            ref.read(my_theme.themeProvider.notifier).toggleTheme();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 42,
            height: 22,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: isDark ? Colors.greenAccent.shade400 : Colors.grey[400],
            ),
            alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
