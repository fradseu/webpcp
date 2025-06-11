import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../provider/user_products.dart';

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class ProdutosPlutoGrid extends ConsumerStatefulWidget {
  final String userEmail; // <-- campo para armazenar o email
  const ProdutosPlutoGrid({super.key, required this.userEmail});
  @override
  ConsumerState<ProdutosPlutoGrid> createState() => ProdutosPlutoGridState();
}

class ProdutosPlutoGridState extends ConsumerState<ProdutosPlutoGrid> {
  PlutoGridStateManager? stateManager;

  @override
  void initState() {
    super.initState();
    // Busca os produtos com o email passado
    Future.microtask(() async {
      await ref
          .read(produtosProvider.notifier)
          .buscarProdutos(widget.userEmail);
    });
  }

  Future<void> recarregarProdutos() async {
    await ref.read(produtosProvider.notifier).buscarProdutos(widget.userEmail);

    final produtos = ref.read(produtosProvider);
    print('Lista atualizada: ${produtos.length} produtos');

    if (stateManager != null) {
      final novasRows = _buildDynamicRows(produtos);
      stateManager!.removeAllRows();
      stateManager!.appendRows(novasRows);
    } else {
      setState(() {}); // Só se ainda não carregou o PlutoGrid
    }
  }

  List<PlutoColumn> _buildDynamicColumns(List<Map<String, dynamic>> produtos) {
    if (produtos.isEmpty) return [];

    final Set<String> fields = produtos.expand((p) => p.keys).toSet();
    final List<String> ordenados = fields.toList()..sort();

    // Ordenar priorizando 'cod' e 'nome'
    const prioridade = ['cod', 'nome'];
    final principais = prioridade.where(ordenados.contains).toList();
    ordenados.removeWhere(prioridade.contains);
    final camposFinais = [...principais, ...ordenados];

    return camposFinais.map((field) {
      final amostra = produtos.first[field];
      PlutoColumnType tipo;

      if (amostra is num) {
        tipo = PlutoColumnType.number();
      } else if (amostra is bool) {
        tipo = PlutoColumnType.select(['true', 'false']);
      } else {
        tipo = PlutoColumnType.text();
      }

      return PlutoColumn(
        title: field[0].toUpperCase() + field.substring(1),
        field: field,
        type: tipo,
        enableEditingMode: false,
      );
    }).toList();
  }

  List<PlutoRow> _buildDynamicRows(List<Map<String, dynamic>> produtos) {
    return produtos.map((produto) {
      final cells = <String, PlutoCell>{
        for (var entry in produto.entries)
          entry.key: PlutoCell(value: entry.value),
      };
      return PlutoRow(cells: cells);
    }).toList();
  }

  void printDadosVisiveis() {
    if (stateManager == null) return;

    final linhasVisiveis = stateManager!.rows; // linhas após filtro/ordenacao
    final colunas = stateManager!.columns; // colunas já ordenadas do PlutoGrid

    final dadosVisiveis =
        linhasVisiveis.map((row) {
          final Map<String, dynamic> linhaMap = {};
          for (var coluna in colunas) {
            final field = coluna.field;
            linhaMap[field] = row.cells[field]?.value;
          }
          return linhaMap;
        }).toList();

    print('Dados visíveis ordenados: $dadosVisiveis');
  }

  Future<void> exportToExcel() async {
    try {
      if (stateManager == null) {
        debugPrint('StateManager é nulo - não pode exportar');
        return;
      }

      debugPrint('Iniciando exportação para Excel...');

      final linhasVisiveis = stateManager!.rows;
      final colunas = stateManager!.columns;

      debugPrint(
        '${linhasVisiveis.length} linhas e ${colunas.length} colunas para exportar',
      );

      var excel = Excel.createExcel();
      String sheetName = 'Produtos';
      Sheet sheetObject = excel[sheetName];

      // Cabeçalho
      sheetObject.appendRow(colunas.map((c) => c.title).toList());

      // Dados
      for (var linha in linhasVisiveis) {
        final linhaValores =
            colunas.map((c) {
              final value = linha.cells[c.field]?.value;
              return value?.toString() ?? '';
            }).toList();
        sheetObject.appendRow(linhaValores);
      }

      // Codificar o Excel para bytes
      final bytes = excel.encode();
      if (bytes == null) {
        debugPrint('Falha ao codificar o arquivo Excel');
        return;
      }

      if (kIsWeb) {
        // Implementação para Web
        final blob = html.Blob([
          bytes,
        ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor =
            html.AnchorElement(href: url)
              ..setAttribute(
                'download',
                'produtos_export_${DateTime.now().millisecondsSinceEpoch}.xlsx',
              )
              ..click();

        html.Url.revokeObjectUrl(url);
      } else {
        // Implementação para mobile/desktop (mantenha seu código original)
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          directory = await getTemporaryDirectory();
        }

        if (directory == null) {
          debugPrint('Não foi possível obter o diretório');
          return;
        }

        final fileName =
            'produtos_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(bytes);
      }

      debugPrint('Arquivo Excel exportado com sucesso');
    } catch (e) {
      debugPrint('Erro durante exportToExcel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtos = ref.watch(produtosProvider);

    final columns = _buildDynamicColumns(produtos);
    final rows = _buildDynamicRows(produtos);

    if (columns.isEmpty) {
      return const Center(child: Text("Nenhum produto encontrado."));
    }

    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (event) {
        stateManager = event.stateManager;

        stateManager!.addListener(() {
          printDadosVisiveis();
        });

        printDadosVisiveis();
      },
      onChanged: (event) {
        // Se quiser imprimir dados após edição
        // printDadosVisiveis();
      },
      configuration: PlutoGridConfiguration(
        localeText: PlutoGridLocaleText.brazilianPortuguese(),
        columnSize: PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.equal,
        ),
      ),
    );
  }
}
