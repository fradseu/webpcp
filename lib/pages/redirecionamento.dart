import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_modulos.dart';
import '../provider/user_products.dart';
import '../provider/user_provider.dart';

class RedirectPage extends ConsumerStatefulWidget {
  const RedirectPage({super.key});

  @override
  ConsumerState<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends ConsumerState<RedirectPage> {
  bool _isLoading = true;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Mensagem inicial
      setState(() {
        _statusMessage = 'Carregando dados do usuário...';
        _isLoading = true;
      });

      // Busca os dados do usuário
      await ref.read(userProvider.notifier).fetchUserData();
      await Future.delayed(const Duration(seconds: 4)); // aguarda 4s

      final userData = ref.read(userProvider);
      debugPrint('Dados do usuário: $userData');

      if (userData == null) {
        setState(() {
          _statusMessage = 'Usuário não autenticado';
          _isLoading = false;
        });
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pushReplacementNamed(context, '/');
        return;
      }

      // Atualiza mensagem para carregamento dos produtos
      setState(() {
        _statusMessage = 'Carregando produtos do usuário...';
      });

      if (userData.email != null) {
        await ref
            .read(produtosProvider.notifier)
            .buscarProdutos(userData.email!);
      }
      await Future.delayed(const Duration(seconds: 4)); // aguarda 4s

      // Carrega os módulos
      // Atualiza mensagem para carregamento dos produtos
      setState(() {
        _statusMessage = 'Carregando módulos do usuário...';
      });
      final modulos = await ref.read(modulosProvider.future);
      debugPrint('Módulos carregados: $modulos');

      await Future.delayed(const Duration(seconds: 3)); // aguarda 4s

      setState(() {
        _statusMessage =
            userData.nome != null
                ? 'Bem-vindo, ${userData.nome}!'
                : 'Bem-vindo!';
        _isLoading = false;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        if (modulos.isEmpty) {
          Navigator.pushReplacementNamed(context, '/');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      debugPrint('Erro na inicialização: $e');
      setState(() {
        _statusMessage = 'Erro ao carregar dados';
        _isLoading = false;
      });
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo/lolaEtheo_baner.png',
                height: 75,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 69, 43, 94),
                        ),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                    ],
                  )
                  : userData != null
                  ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40,
                  )
                  : const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 16),
              Text(_statusMessage),
              if (userData != null) ...[
                const SizedBox(height: 24),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (userData.perfil != null)
                          ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: const Text('Perfil'),
                            subtitle: Text(
                              userData.perfil!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
