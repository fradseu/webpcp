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

      // Seleciona o arquivo Excel
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

      // Configuração do overlay de progresso
      int progress = 0;
      int total = rows.length - 1; // Descontando o cabeçalho
      bool isComplete = false;
      late StateSetter dialogSetState;

      // Mostrar overlay de progresso
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              dialogSetState = setState;
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

      // Processa cabeçalhos (convertendo para lowercase para padronização)
      final header =
          rows.first
              .map((e) => e?.value.toString().toLowerCase().trim() ?? '')
              .toList();
      rows = rows.sublist(1); // Remove linha de cabeçalho

      // Obtém referência do Firestore
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

      // Processa cada linha
      for (var i = 0; i < rows.length; i++) {
        final row = rows[i];
        final data = <String, dynamic>{};

        // Mapeia cada célula baseado no cabeçalho
        for (var j = 0; j < row.length; j++) {
          if (j >= header.length) break;
          final columnName = header[j];
          if (columnName.isEmpty) continue;

          final cellValue = row[j]?.value;

          // Conversão de tipos específicos
          if (columnName == 'quantidade' ||
              columnName == 'estoque min' ||
              columnName == 'estoque máximo') {
            data[columnName] =
                cellValue is num
                    ? cellValue.toInt()
                    : int.tryParse(cellValue?.toString() ?? '') ?? 0;
          } else if (columnName == 'peso' ||
              columnName == 'volume' ||
              columnName == 'altura' ||
              columnName == 'largura' ||
              columnName == 'comprimento') {
            data[columnName] =
                cellValue is num
                    ? cellValue.toDouble()
                    : double.tryParse(cellValue?.toString() ?? '') ?? 0.0;
          } else if (columnName == 'ativo') {
            data[columnName] =
                (cellValue?.toString().toLowerCase() == 'sim' ||
                    cellValue?.toString().toLowerCase() == 'yes' ||
                    cellValue?.toString().toLowerCase() == 'true');
          } else {
            data[columnName] = cellValue?.toString() ?? '';
          }
        }

        // Campos obrigatórios
        if (!data.containsKey('cod') || data['cod']?.toString().isEmpty == true)
          continue;

        // Verifica se documento já existe
        final existing =
            await produtosRef
                .where('cod', isEqualTo: data['cod']?.toString())
                .limit(1)
                .get();

        if (existing.docs.isNotEmpty) {
          await existing.docs.first.reference.update(data);
        } else {
          await produtosRef.add(data);
        }

        progress++;
        dialogSetState(() {});
      }

      isComplete = true;
      dialogSetState(() {});

      // Fecha automaticamente após 2 segundos se concluído
      if (isComplete) {
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Importação concluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Erro ao importar Excel: $e');
      Navigator.of(context).pop(); // Fecha o overlay se estiver aberto
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao importar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
