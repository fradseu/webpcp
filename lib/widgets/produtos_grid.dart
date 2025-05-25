import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../pages/produtos.dart';
import '../provider/user_provider.dart';

class ProdutosPlutoGrid extends ConsumerStatefulWidget {
  const ProdutosPlutoGrid({super.key});

  @override
  ConsumerState<ProdutosPlutoGrid> createState() => _ProdutosPlutoGridState();
}

class _ProdutosPlutoGridState extends ConsumerState<ProdutosPlutoGrid> {
  late List<PlutoColumn> columns;
  List<PlutoRow> rows = [];

  PlutoGridStateManager? stateManager;

  @override
  void initState() {
    super.initState();
    columns = _buildColumns();
  }

  List<PlutoColumn> _buildColumns() {
    return [
      PlutoColumn(title: 'Nome', field: 'nome', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Preço',
        field: 'preco',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Categoria',
        field: 'categoria',
        type: PlutoColumnType.text(),
      ),
    ];
  }

  List<PlutoRow> _buildRows(List<Map<String, dynamic>> produtos) {
    return produtos.map((produto) {
      return PlutoRow(
        cells: {
          'nome': PlutoCell(value: produto['nome'] ?? ''),
          'preco': PlutoCell(value: produto['preco'] ?? 0.0),
          'categoria': PlutoCell(value: produto['categoria'] ?? ''),
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final produtos = ref.watch(produtosProvider);

    rows = _buildRows(produtos); // atualiza os rows

    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        debugPrint('Valor alterado: ${event.value}');
        debugPrint('Coluna: ${event.column.field}');
        debugPrint('Células da linha:');
        event.row.cells.forEach((key, cell) {
          debugPrint('$key: ${cell.value}');
        });
      },

      configuration: PlutoGridConfiguration(
        columnSize: PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.equal,
        ),
      ),
    );
  }
}
