import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../widgets/loadprodutos.dart';

// Notifier que controla o estado da lista de produtos
class ProdutosNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ProdutosNotifier() : super([]);

  final LoadProdutos loader = LoadProdutos();

  Future<void> buscarProdutos(String email) async {
    final produtos = await loader.buscarProdutosDoUsuario(email);
    state = produtos;

    // Print para confirmar o estado
    //debugPrint('Produtos carregados no provider: $state');
  }
}

// Provider global que pode ser usado na aplicação
final produtosProvider =
    StateNotifierProvider<ProdutosNotifier, List<Map<String, dynamic>>>(
      (ref) => ProdutosNotifier(),
    );
