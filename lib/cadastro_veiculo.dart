import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/models/veiculo.dart';
import 'package:uuid/uuid.dart';

class CadastroVeiculo extends StatefulWidget {
  @override
  _CadastroVeiculoState createState() => _CadastroVeiculoState();
}

class _CadastroVeiculoState extends State<CadastroVeiculo> {
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _anoFabricacaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Veículo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _marcaController,
              decoration: InputDecoration(labelText: 'Marca'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _modeloController,
              decoration: InputDecoration(labelText: 'Modelo'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _placaController,
              decoration: InputDecoration(labelText: 'Placa'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _anoFabricacaoController,
              decoration: InputDecoration(labelText: 'Ano fabricacao'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                salvarDados();
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void salvarDados() {
    Veiculo veiculo = new Veiculo(
        id: const Uuid().v1(),
        placa: _placaController.text,
        modelo: _modeloController.text,
        marca: _marcaController.text,
        ano_fabricacao: int.parse(_anoFabricacaoController.text));
    FirebaseFirestore.instance.collection('veiculos').doc(veiculo.id).set(veiculo.toMap()).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucesso'),
            content: Text('Dados salvos com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Ocorreu um erro ao salvar os dados.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/master
