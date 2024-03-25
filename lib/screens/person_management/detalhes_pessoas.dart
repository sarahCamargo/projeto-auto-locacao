import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalhesPessoaScreen extends StatelessWidget {
  final Map<String, dynamic> pessoa;

  DetalhesPessoaScreen({required this.pessoa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Pessoa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${pessoa['nome']}'),
            Text('CPF: ${pessoa['cpf']}'),
            // Adicione outros campos conforme necessário
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implemente a lógica para editar a pessoa
              },
              child: Text('Editar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implemente a lógica para excluir a pessoa
              },
              child: Text('Excluir'),
            ),
          ],
        ),
      ),
    );
  }
}
