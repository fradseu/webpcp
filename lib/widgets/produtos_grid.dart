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

final produtosProvider =
    StateNotifierProvider<ProdutosNotifier, List<Map<String, dynamic>>>(
      (ref) => ProdutosNotifier(),
    );

class ProdutosPlutoGrid extends ConsumerStatefulWidget {
  const ProdutosPlutoGrid({super.key});

  @override
  ConsumerState<ProdutosPlutoGrid> createState() => ProdutosPlutoGridState();
}

class ProdutosPlutoGridState extends ConsumerState<ProdutosPlutoGrid> {
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
    if (stateManager == null) return;

    final visibleRows = stateManager!.rows;
    if (visibleRows.isEmpty) return;

    // Cria o Excel com apenas a aba "Produtos" (evitando Sheet1)
    final excel = Excel.createExcel();
    final sheet = excel['Produtos']; // Isso já cria a aba se não existir

    final headers = columns.map((c) => c.field).toList();
    sheet.appendRow(headers);

    for (final row in visibleRows) {
      final rowData =
          headers.map((h) => row.cells[h]?.value?.toString() ?? '').toList();
      sheet.appendRow(rowData);
    }

    try {
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
                ..download = 'produtos_filtrados.xlsx'
                ..style.display = 'none';

          html.document.body?.children.add(anchor);
          anchor.click();
          html.document.body?.children.remove(anchor);
          html.Url.revokeObjectUrl(url);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exportação concluída!')),
          );
        }
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/produtos_filtrados.xlsx';
        final fileBytes = excel.encode();

        if (fileBytes != null) {
          final file = File(filePath);
          await file.writeAsBytes(fileBytes);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Arquivo salvo em: $filePath')),
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
              //debugPrint('Valor alterado: ${event.value}');
              //debugPrint('Coluna: ${event.column.field}');
              //debugPrint('Linha completa: ${event.row.cells}');
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
