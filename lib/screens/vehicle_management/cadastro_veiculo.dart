import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/models/veiculo.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/listar_veiculos.dart';
import 'package:uuid/uuid.dart';

class CadastroVeiculo extends StatefulWidget {
  @override
  _CadastroVeiculoState createState() => _CadastroVeiculoState();

  final Map<String, dynamic> veiculo;

  CadastroVeiculo({required this.veiculo});
}

class _CadastroVeiculoState extends State<CadastroVeiculo> {
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _anoFabricacaoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   if (widget.veiculo["id"] != null) {
     _marcaController.text = widget.veiculo["marca"];
     _modeloController.text = widget.veiculo["modelo"];
     _placaController.text = widget.veiculo["placa"];
     _anoFabricacaoController.text = widget.veiculo["ano_fabricacao"].toString();
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Veículo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
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
    if(widget.veiculo["id"] == null) {
      Veiculo veiculo = new Veiculo(
          id: const Uuid().v1(),
          placa: _placaController.text,
          modelo: _modeloController.text,
          marca: _marcaController.text,
          ano_fabricacao: int.parse(_anoFabricacaoController.text));
      FirebaseFirestore.instance.collection('veiculos').doc(veiculo.id).set(
          veiculo.toMap()).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados salvos com sucesso')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados: $error')),
        );
      });
    }
    else {
      FirebaseFirestore.instance.collection('veiculos').doc(widget.veiculo["id"]).update({
        "placa": _placaController.text,
        "marca": _marcaController.text,
        "modelo": _modeloController.text,
        "ano_fabricacao": _anoFabricacaoController.text
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados salvos com sucesso')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListarVeiculos()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados: $error')),
        );
      });
    }
  }
}



