import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/theme_provider.dart' as my_theme;

class CustomDropdownMenu extends ConsumerStatefulWidget {
  const CustomDropdownMenu({super.key});

  @override
  ConsumerState<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends ConsumerState<CustomDropdownMenu> {
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;

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

  void _toggleMenu() {
    if (_overlayEntry == null) {
      final renderBox =
          _menuKey.currentContext!.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry = OverlayEntry(
        builder:
            (context) => Stack(
              children: [
                // Camada para capturar toques fora do menu
                GestureDetector(
                  onTap: _toggleMenu,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),

                // Menu propriamente dito
                Positioned(
                  top: offset.dy + renderBox.size.height,
                  left: offset.dx - 110,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).cardColor,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            _menuItems.map((item) {
                              if (item['title'] == 'divider') {
                                return const Divider(height: 1);
                              } else if (item['isToggle'] == true) {
                                return _buildToggleRow(item);
                              } else {
                                return InkWell(
                                  onTap: () => _onItemSelected(item['title']),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          item['icon'],
                                          size: 18,
                                          color:
                                              item['isSpecial'] == true
                                                  ? Colors.red
                                                  : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item['title'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  item['isSpecial'] == true
                                                      ? Colors.red
                                                      : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      );

      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _onItemSelected(String value) async {
    _toggleMenu(); // Fecha o menu

    if (value == 'Sair') {
      try {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao sair: $e')));
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$value selecionado')));
      }
    }
  }

  Widget _buildToggleRow(Map<String, dynamic> item) {
    final isDark =
        ref.watch(my_theme.themeProvider) == my_theme.AppThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(item['title'], style: const TextStyle(fontSize: 14)),
          ),
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
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // muda o cursor ao passar o mouse
      child: GestureDetector(
        key: _menuKey,
        onTap: _toggleMenu,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu,
                size: 18,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 8),
              Text(
                "Menu",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 18,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
