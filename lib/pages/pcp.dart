import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../provider/theme_provider.dart' as my_theme;
import '../provider/user_products.dart';
import '../provider/user_provider.dart';
import '../widgets/btn_novo_produto.dart';
import '../widgets/home_grid.dart';
import '../widgets/custom_appbar.dart';

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html; // Para Flutter Web

const String nomePagina = "Produtos";

class PcpPage extends ConsumerStatefulWidget {
  const PcpPage({super.key});

  @override
  ConsumerState<PcpPage> createState() => _PcpPageState();
}

class _PcpPageState extends ConsumerState<PcpPage> {
  final GlobalKey<_ProdutosPlutoGridState> _gridKey =
      GlobalKey<_ProdutosPlutoGridState>();

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
          'PCP Page',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: const [CustomDropdownMenu(), SizedBox(width: 10)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isWide = constraints.maxWidth >= 800;
                final double containerWidth =
                    isWide ? constraints.maxWidth / 3 : constraints.maxWidth;
                final containers = [
                  Container(
                    width: containerWidth,
                    height: 50,
                    color: Colors.amber,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BtnNovoProduto(),
                        SizedBox(width: 8),

                        ElevatedButton(
                          onPressed: () {
                            final produtos = ref.read(produtosProvider);
                            _gridKey.currentState?.exportToExcel(produtos);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.download),
                              SizedBox(width: 4),
                              Text("Exportar Excel"),
                            ],
                          ),
                        ),
                        const Text(
                          nomePagina,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 8),
                        const Icon(Icons.settings, color: Colors.white),
                      ],
                    ),
                  ),

                  Container(
                    width: containerWidth,
                    height: 50,
                    color: Colors.blue,
                  ),
                  Container(
                    width: containerWidth,
                    height: 50,
                    color: Colors.amber,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final userData = ref.read(userProvider);
                            if (userData != null && userData.email != null) {
                              await ref
                                  .read(produtosProvider.notifier)
                                  .buscarProdutos(userData.email!);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                              0,
                              42,
                            ), // largura mínima 0, altura 32px
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ), // opcional
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.update, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Atualizar',
                                style: TextStyle(fontSize: 12),
                              ), // fonte menor se quiser
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
                  child: ProdutosPlutoGrid(key: _gridKey),
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

class ProdutosPlutoGrid extends ConsumerStatefulWidget {
  const ProdutosPlutoGrid({super.key});

  @override
  ConsumerState<ProdutosPlutoGrid> createState() => _ProdutosPlutoGridState();
}

class _ProdutosPlutoGridState extends ConsumerState<ProdutosPlutoGrid> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;

  List<PlutoColumn> _buildDynamicColumns(List<Map<String, dynamic>> produtos) {
    if (produtos.isEmpty) return [];

    final Set<String> fields = produtos.expand((p) => p.keys).toSet();

    return fields.map((field) {
      final sampleValue = produtos.first[field];
      PlutoColumnType type;

      if (sampleValue is num) {
        type = PlutoColumnType.number();
      } else if (sampleValue is bool) {
        type = PlutoColumnType.select(['true', 'false']);
      } else {
        type = PlutoColumnType.text();
      }

      return PlutoColumn(
        enableEditingMode: false,
        title: field[0].toUpperCase() + field.substring(1),
        field: field,
        type: type,
      );
    }).toList();
  }

  List<PlutoRow> _buildDynamicRows(List<Map<String, dynamic>> produtos) {
    return produtos.map((produto) {
      final cells = <String, PlutoCell>{};
      produto.forEach((key, value) {
        cells[key] = PlutoCell(value: value);
      });
      return PlutoRow(cells: cells);
    }).toList();
  }

  Future<void> exportToExcel(List<Map<String, dynamic>> produtos) async {
    final excel = Excel.createExcel();
    final sheet = excel['Produtos'];

    if (produtos.isEmpty) return;

    // Adiciona cabeçalhos
    final headers = produtos.first.keys.toList();
    sheet.appendRow(headers);

    // Adiciona dados
    for (var produto in produtos) {
      final row = headers.map((k) => produto[k]?.toString() ?? '').toList();
      sheet.appendRow(row);
    }

    try {
      // Para Flutter Web, usamos a API de download no navegador
      if (kIsWeb) {
        final bytes = excel.encode();
        if (bytes != null) {
          final blob = html.Blob(
            [bytes],
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          );
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor =
              html.document.createElement('a') as html.AnchorElement
                ..href = url
                ..download = 'produtos_exportados.xlsx'
                ..style.display = 'none';

          html.document.body?.children.add(anchor);
          anchor.click();

          // Limpeza
          html.document.body?.children.remove(anchor);
          html.Url.revokeObjectUrl(url);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Arquivo exportado com sucesso!')),
          );
        }
      } else {
        // Código para outras plataformas (mobile/desktop)
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/produtos_exportados.xlsx';
        final fileBytes = excel.encode();

        if (fileBytes != null) {
          final file = File(filePath);
          await file.writeAsBytes(fileBytes);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Arquivo exportado: $filePath')),
          );
        }
      }
    } catch (e) {
      debugPrint("Erro ao exportar: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao exportar arquivo')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtos = ref.watch(produtosProvider);

    columns = _buildDynamicColumns(produtos);
    rows = _buildDynamicRows(produtos);

    if (columns.isEmpty) {
      return const Center(child: Text("Nenhum produto encontrado."));
    }

    return Column(
      children: [
        Expanded(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            onLoaded: (event) => stateManager = event.stateManager,
            onChanged: (event) {
              debugPrint('Valor alterado: ${event.value}');
              debugPrint('Coluna: ${event.column.field}');
              debugPrint('Linha completa: ${event.row.cells}');
            },
            configuration: PlutoGridConfiguration(
              localeText: PlutoGridLocaleText.brazilianPortuguese(),
              columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.equal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
