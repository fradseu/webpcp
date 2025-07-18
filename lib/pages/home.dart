import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../provider/theme_provider.dart' as my_theme;
import '../provider/user_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/home_grid.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Carrega os dados quando o widget é inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });
  }

  // Método para carregar todos os dados necessários
  Future<void> _loadAllData() async {
    await ref.read(userProvider.notifier).fetchUserData();
    // O modulosProvider vai se atualizar automaticamente quando o userProvider mudar
  }

  //Future<void> _logout(BuildContext context) async {
  //  await FirebaseAuth.instance.signOut();
  //  if (context.mounted) {
  //    Navigator.pushReplacementNamed(context, '/login');
  //  }
  //}

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final theme = Theme.of(context);
    //final themeMode = ref.watch(my_theme.themeProvider);

    // Mostra um indicador de carregamento enquanto os dados estão sendo buscados
    if (userData == null) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.inkDrop(
            color: Color.fromARGB(255, 85, 57, 112),
            size: 36,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          //IconButton(
          //  icon: Icon(
          //    themeMode == my_theme.AppThemeMode.dark
          //        ? Icons.light_mode
          //        : Icons.dark_mode,
          //  ),
          //  tooltip: 'Alternar tema',
          //  onPressed:
          //      () => ref.read(my_theme.themeProvider.notifier).toggleTheme(),
          //),
          CustomDropdownMenu(),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Grid alinhado no topo e centralizado horizontalmente
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ), // Espaço do topo (opcional)
              child: ModulosGrid(),
            ),
          ),
          // Espaço flexível para empurrar o botão para baixo
          const Spacer(),
        ],
      ),
    );
  }
}
