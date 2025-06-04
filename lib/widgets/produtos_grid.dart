import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../provider/user_products.dart';

class ProdutosPlutoGrid extends ConsumerStatefulWidget {
  const ProdutosPlutoGrid({super.key});

  @override
  ConsumerState<ProdutosPlutoGrid> createState() => ProdutosPlutoGridState();
}

class ProdutosPlutoGridState extends ConsumerState<ProdutosPlutoGrid> {
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

    final excel = Excel.createExcel();
    final sheet = excel['Produtos'];

    final headers = stateManager!.columns.map((c) => c.field).toList();
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
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor =
              html.AnchorElement(href: url)
                ..setAttribute("download", "produtos.xlsx")
                ..click();
          html.Url.revokeObjectUrl(url);
        }
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file =
            File("${dir.path}/produtos.xlsx")
              ..createSync(recursive: true)
              ..writeAsBytesSync(excel.encode()!);
      }
    } catch (e) {
      // Tratar erro se necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtos = ref.watch(produtosProvider);

    if (produtos.isEmpty) {
      return const Center(child: Text('Nenhum produto encontrado.'));
    }

    final columns = _buildDynamicColumns(produtos);
    final rows = _buildDynamicRows(produtos);

    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
      },
      onChanged: (PlutoGridOnChangedEvent event) {},
      configuration: const PlutoGridConfiguration(),
    );
  }
}
