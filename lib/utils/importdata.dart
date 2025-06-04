import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportData {
  static Future<void> importExcelData(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado.');

      final userEmail = user.email ?? '';
      if (userEmail.isEmpty) throw Exception('E-mail não encontrado.');

      // Primeiro seleciona o arquivo
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (result == null || result.files.single.bytes == null) {
        throw Exception('Nenhum arquivo selecionado.');
      }

      Uint8List fileBytes = result.files.single.bytes!;
      var excel = Excel.decodeBytes(fileBytes);

      if (!excel.tables.containsKey('Produtos')) {
        throw Exception('A aba "Produtos" não foi encontrada.');
      }

      var rows = excel.tables['Produtos']!.rows;
      if (rows.isEmpty) throw Exception('A planilha está vazia.');

      // Agora que temos o número de linhas, mostramos o overlay
      int progress = 0;
      int total = rows.length - 1; // Descontando o cabeçalho
      bool isComplete = false;

      // Controlador de atualização do overlay
      late StateSetter dialogSetState;

      // Mostrar overlay após determinar o total
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              dialogSetState = setState; // salvar o setter para uso externo
              return AlertDialog(
                title: Text(isComplete ? 'Upload completo' : 'Importando...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: total > 0 ? progress / total : 0,
                    ),
                    SizedBox(height: 16),
                    Text('$progress de $total linhas processadas'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(isComplete ? 'Fechar' : 'Cancelar'),
                  ),
                ],
              );
            },
          );
        },
      );

      final header = rows.first.map((e) => e?.value.toString() ?? '').toList();
      rows = rows.sublist(1);

      final query =
          await FirebaseFirestore.instance
              .collection('user_produtcs')
              .where('email', isEqualTo: userEmail)
              .get();

      if (query.docs.isEmpty) {
        throw Exception('Documento com o e-mail $userEmail não encontrado.');
      }

      final docId = query.docs.first.id;
      final produtosRef = FirebaseFirestore.instance
          .collection('user_produtcs')
          .doc(docId)
          .collection('produtos');

      for (var i = 0; i < rows.length; i++) {
        final values =
            rows[i].map((cell) => cell?.value.toString() ?? '').toList();

        if (values.length < 3) continue;

        final cod = values[0];
        final quantidade = int.tryParse(values[1]) ?? 0;
        final nome = values[2];
        final referencia = values.length > 3 ? values[3] : '';
        final descricao = values.length > 4 ? values[4] : '';
        final unidade = values.length > 5 ? values[5] : '';
        final altura = values.length > 6 ? values[6] : '';
        final largura = values.length > 7 ? values[7] : '';
        final comprimento = values.length > 8 ? values[8] : '';
        final peso = values.length > 9 ? values[9] : '';
        final volume = values.length > 10 ? values[10] : '';
        final tempoProducao = values.length > 11 ? values[11] : '';
        final multiProducao = values.length > 12 ? values[12] : '';
        final tipoProcessamento = values.length > 13 ? values[13] : '';
        final recursoPrincipal = values.length > 14 ? values[14] : '';
        final setup = values.length > 15 ? values[15] : '';
        final grupo = values.length > 16 ? values[16] : '';
        final familia = values.length > 17 ? values[17] : '';
        final ativo = values.length > 18 ? values[18] : '';
        final leadTime = values.length > 19 ? values[19] : '';
        final estoqueMin = values.length > 20 ? values[20] : '';
        final estoqueMax = values.length > 21 ? values[21] : '';
        final observacoes = values.length > 22 ? values[22] : '';

        final existing =
            await produtosRef.where('cod', isEqualTo: cod).limit(1).get();

        if (existing.docs.isNotEmpty) {
          await existing.docs.first.reference.update({
            'quantidade': quantidade,
            'nome': nome,
            'referência': referencia,
            'descrição': descricao,
            'unidade': unidade,
            'altura': altura,
            'largura': largura,
            'comprimento': comprimento,
            'peso': peso,
            'volume': volume,
            'tempo de produção': tempoProducao,
            'multi. produção': multiProducao,
            'tipo processamento': tipoProcessamento,
            'recurso principal': recursoPrincipal,
            'setup': setup,
            'grupo': grupo,
            'familia': familia,
            'ativo': ativo,
            'lead time': leadTime,
            'estoque min': estoqueMin,
            'estoque máximo': estoqueMax,
            'observações': observacoes,
          });
        } else {
          await produtosRef.add({
            'cod': cod,
            'quantidade': quantidade,
            'nome': nome,
            'referência': referencia,
            'descrição': descricao,
            'unidade': unidade,
            'altura': altura,
            'largura': largura,
            'comprimento': comprimento,
            'peso': peso,
            'volume': volume,
            'tempo de produção': tempoProducao,
            'multi. produção': multiProducao,
            'tipo processamento': tipoProcessamento,
            'recurso principal': recursoPrincipal,
            'setup': setup,
            'grupo': grupo,
            'familia': familia,
            'ativo': ativo,
            'lead time': leadTime,
            'estoque min': estoqueMin,
            'estoque máximo': estoqueMax,
            'observações': observacoes,
          });
        }

        progress++;
        dialogSetState(() {});
      }

      isComplete = true;
      dialogSetState(() {}); // Força troca do botão "Cancelar" para "Fechar"
    } catch (e) {
      print('Erro ao importar Excel: $e');
      Navigator.of(context).pop(); // Fecha o overlay se estiver aberto
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao importar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
