import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../provider/theme_provider.dart' as my_theme;
import '../provider/user_provider.dart';
import '../widgets/home_grid.dart';
import '../widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String nomePagina = "Produtos";

class ProdutosPage extends ConsumerStatefulWidget {
  const ProdutosPage({super.key});

  @override
  ConsumerState<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends ConsumerState<ProdutosPage> {
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
          'Produtos Page',
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
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Botão'),
                        ),
                        SizedBox(width: 8),
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
            Align(alignment: Alignment.topCenter, child: ModulosGrid()),
            const SizedBox(height: 24), // Espaço no fim do scroll
          ],
        ),
      ),
    );
  }
}

// ================================================
// CLASSE SIMPLES PARA BUSCAR PRODUTOS DO FIREBASE
// ================================================
// Classe que busca os produtos do Firestore

class LoadProdutos {
  Future<List<Map<String, dynamic>>> buscarProdutosDoUsuario(
    String email,
  ) async {
    List<Map<String, dynamic>> produtosList = [];

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('user_produtcs')
              .where('email', isEqualTo: email)
              .get();

      if (snapshot.docs.isEmpty) {
        debugPrint('Nenhum usuário com email $email encontrado.');
        return produtosList;
      }

      for (var doc in snapshot.docs) {
        final userDocId = doc.id;
        debugPrint('Usuário encontrado: ${doc.data()}');

        final produtosSnapshot =
            await FirebaseFirestore.instance
                .collection('user_produtcs')
                .doc(userDocId)
                .collection('produtos')
                .get();

        if (produtosSnapshot.docs.isEmpty) {
          debugPrint('Nenhum produto encontrado para o usuário $email.');
        } else {
          for (var produto in produtosSnapshot.docs) {
            produtosList.add(produto.data());
          }
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar produtos do usuário: $e');
    }

    return produtosList;
  }
}

// Notifier que controla o estado da lista de produtos
class ProdutosNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ProdutosNotifier() : super([]);

  final LoadProdutos loader = LoadProdutos();

  Future<void> buscarProdutos(String email) async {
    final produtos = await loader.buscarProdutosDoUsuario(email);
    state = produtos;

    // Print para confirmar o estado
    debugPrint('Produtos carregados no provider: $state');
  }
}

// Provider global que pode ser usado na aplicação
final produtosProvider =
    StateNotifierProvider<ProdutosNotifier, List<Map<String, dynamic>>>(
      (ref) => ProdutosNotifier(),
    );
