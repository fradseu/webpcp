import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
//import 'package:pluto_grid/pluto_grid.dart';
//import '../provider/theme_provider.dart' as my_theme;
import '../provider/user_products.dart';
import '../provider/user_provider.dart';
import '../utils/importdata.dart';
import '../widgets/btn_novo_produto.dart';
import '../widgets/custom_appbar.dart';

//import 'dart:io';
//import 'package:excel/excel.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:path_provider/path_provider.dart';
//import 'package:universal_html/html.dart' as html;

import '../widgets/produtos_grid.dart'; // Para Flutter Web

const String nomePagina = "Produtos";

class ProdutosPage extends ConsumerStatefulWidget {
  const ProdutosPage({super.key});

  @override
  ConsumerState<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends ConsumerState<ProdutosPage> {
  final GlobalKey<ProdutosPlutoGridState> gridKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });
  }

  Future<void> _loadAllData() async {
    await ref.read(userProvider.notifier).fetchUserData();

    final userData = ref.read(userProvider);
    if (userData != null && userData.email != null) {
      await ref.read(produtosProvider.notifier).buscarProdutos(userData.email!);
    }
  }

  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _toggleMenu() {
    if (_overlayEntry == null) {
      final renderBox =
          _menuKey.currentContext!.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry = OverlayEntry(
        builder:
            (context) => Stack(
              children: [
                GestureDetector(
                  onTap: _toggleMenu,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                  ),
                ),
                Positioned(
                  top: offset.dy + renderBox.size.height,
                  left: offset.dx - 100,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).cardColor,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              await ImportData.importExcelData(context);
                              _toggleMenu();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.upload_file, size: 18),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Importar",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          InkWell(
                            onTap: () async {
                              if (gridKey.currentState != null) {
                                await gridKey.currentState!.exportToExcel();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  //cliquei no botão para exportar travou o vscode e nao exportou nada
                                  const SnackBar(
                                    content: Text('Exportação concluída!'),
                                  ),
                                );
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.download, size: 18),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Exportar",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final theme = Theme.of(context);

    if (userData == null) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.inkDrop(
            color: const Color.fromARGB(255, 85, 57, 112),
            size: 36,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produtos Page',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: const [CustomDropdownMenu(), SizedBox(width: 10)],
      ),
      body: SingleChildScrollView(
        //padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isWide = constraints.maxWidth >= 800;
                final double containerWidth =
                    isWide ? constraints.maxWidth / 3 : constraints.maxWidth;
                final containerColor =
                    Theme.of(
                      context,
                    ).colorScheme.onTertiary; // Cor definida uma única vez
                final containers = [
                  Container(
                    width: containerWidth,
                    height: 50,
                    color: containerColor, // Usando a variável aqui
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BtnNovoProduto(),
                        SizedBox(width: 8),
                        const Text(
                          nomePagina,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 8),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            key: _menuKey,
                            onTap: _toggleMenu,
                            child: Icon(
                              Icons.settings,
                              color: Theme.of(context).splashColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: containerWidth,
                    height: 50,
                    color: containerColor, // Usando a variável aqui
                  ),
                  Container(
                    width: containerWidth,
                    height: 50,
                    color: containerColor, // Usando a variável aqui
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (gridKey.currentState != null) {
                              await gridKey.currentState!.recarregarProdutos();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).splashColor,
                            minimumSize: const Size(0, 42),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.update, size: 18),
                              SizedBox(width: 8),
                              Text('Atualizar', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ];

                return isWide
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: containers,
                    )
                    : Wrap(spacing: 8, runSpacing: 8, children: containers);
              },
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 400,
                  child: ProdutosPlutoGrid(
                    key: gridKey,
                    userEmail: userData.email!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final produtosProvider =
    StateNotifierProvider<ProdutosNotifier, List<Map<String, dynamic>>>(
      (ref) => ProdutosNotifier(),
    );
