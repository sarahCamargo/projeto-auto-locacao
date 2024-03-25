import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalhesVeiculoScreen extends StatelessWidget {
  final Map<String, dynamic> veiculo;
  

  DetalhesVeiculoScreen({required this.veiculo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do veículo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Placa: ${veiculo['placa']}'),
            Text('Modelo: ${veiculo['modelo']}'),
            Text('Marca: ${veiculo['marca']}'),
            Text('Ano fabricação: ${veiculo['ano_fabricacao']}'),
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
                FirebaseFirestore.instance.collection("veiculos").doc(veiculo['id']).delete().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veiculo deletado com sucesso')),
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao deletar veiculo: $error')),
                  );
                });
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
