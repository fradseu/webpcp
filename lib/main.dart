import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_builder/responsive_builder.dart';

//import de páginas
import 'pages/login.dart';
import 'pages/home.dart'; // Contém MobileHomePage, TabletHomePage, DesktopHomePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCQ4PZMuEtFPs7dwtALSLVjOVO_2yWffw",
        authDomain: "lta-automacao.firebaseapp.com",
        projectId: "lta-automacao",
        storageBucket: "lta-automacao.appspot.com",
        messagingSenderId: "848545802671",
        appId: "1:848545802671:web:c7e42e4865cd59b9caa75a",
        measurementId: "G-R6RKW7CM8W",
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
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web PCP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home:
          user == null
              ? const LoginPage()
              : ScreenTypeLayout.builder(
                mobile: (_) => const MobileHomePage(),
                tablet: (_) => const TabletHomePage(),
                desktop: (_) => const DesktopHomePage(),
              ),
    );
  }
}
