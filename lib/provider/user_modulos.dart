import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_provider.dart'; // para acessar os dados do usuário

final modulosProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(userProvider);

  if (user == null || user.modulos == null || user.modulos!.isEmpty) return [];

  final firestore = FirebaseFirestore.instance;
  final modulosData = <Map<String, dynamic>>[];

  for (final moduloId in user.modulos!) {
    final doc = await firestore.collection('main_modulos').doc(moduloId).get();
    if (doc.exists) {
      modulosData.add(doc.data()!..['id'] = doc.id);
    }
  }

  return modulosData;
});
