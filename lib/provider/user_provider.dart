import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserData {
  final String? uid;
  final String? email;
  final String? nome;
  final String? perfil;
  final List<String>? modulos;
  final Map<String, dynamic>? rawData;

  UserData({
    this.uid,
    this.email,
    this.nome,
    this.perfil,
    this.modulos,
    this.rawData,
  });

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserData(
      uid: doc.id,
      email: data['email'] as String?,
      nome: data['nome'] as String?,
      perfil: data['perfil'] as String?,
      modulos:
          data['modulos'] != null
              ? List<String>.from(data['modulos'] as List)
              : null,
      rawData: data,
    );
  }

  @override
  String toString() {
    return 'UserData(uid: $uid, email: $email, nome: $nome, perfil: $perfil, '
        'modulos: $modulos)';
  }
}

class UserNotifier extends StateNotifier<UserData?> {
  UserNotifier() : super(null);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        //debugPrint('⚠️ Nenhum usuário autenticado');
        state = null;
        return;
      }

      //debugPrint('🔍 Buscando dados do usuário: ${user.email}');

      final query =
          await _firestore
              .collection('main_user')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        //debugPrint(
        //  '⚠️ Nenhum documento encontrado para o email: ${user.email}',
        //);
        state = UserData(uid: user.uid, email: user.email);
        return;
      }

      final userDoc = query.docs.first;
      state = UserData.fromFirestore(userDoc);

      //debugPrint('✅ Dados do usuário carregados: ${state.toString()}');
    } on FirebaseException catch (e, stack) {
      //debugPrint('🔥 Erro no Firebase: ${e.message}');
      //debugPrint('Stack trace: $stack');
      state = null;
      rethrow;
    } catch (e, stack) {
      //debugPrint('💥 Erro inesperado: $e');
      //debugPrint('Stack trace: $stack');
      state = null;
      rethrow;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updates) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || state == null) {
        throw Exception('Usuário não autenticado');
      }

      await _firestore.collection('main_user').doc(state!.uid).update(updates);

      await fetchUserData(); // Atualiza o estado com os novos dados
    } catch (e) {
      //debugPrint('Erro ao atualizar usuário: $e');
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      await _auth.signOut();
      state = null;
      //debugPrint('🚪 Usuário deslogado com sucesso');
    } catch (e) {
      //debugPrint('Erro ao deslogar: $e');
      rethrow;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserData?>((ref) {
  return UserNotifier();
});

// Provider auxiliar para acessar apenas os módulos
final userModulesProvider = Provider<List<String>>((ref) {
  final userData = ref.watch(userProvider);
  return userData?.modulos ?? [];
});
