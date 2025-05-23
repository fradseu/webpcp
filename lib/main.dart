import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'provider/theme_provider.dart'; // Remova o alias
import 'theme/custom_theme.dart';

import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/redirecionamento.dart';
import 'pages/produtos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBv2l-pr0iPt7RzTRJOecTVffGBCRur9ns",
        authDomain: "webpcp.firebaseapp.com",
        projectId: "webpcp",
        storageBucket: "webpcp.appspot.com",
        messagingSenderId: "325114564489",
        appId: "1:325114564489:web:2e502f98fee2008ea2db58",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider); // Agora sem o alias

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WEB-PCP',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode:
          themeMode == AppThemeMode.light ? ThemeMode.light : ThemeMode.dark,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/redirect': (context) => const RedirectPage(),
        '/home': (context) => const HomePage(),
        '/produtos': (context) => const ProdutosPage(),
      },
    );
  }
}
