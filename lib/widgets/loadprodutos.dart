// ================================================
// CLASSE SIMPLES PARA BUSCAR PRODUTOS DO FIREBASE
// ================================================
// Classe que busca os produtos do Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
