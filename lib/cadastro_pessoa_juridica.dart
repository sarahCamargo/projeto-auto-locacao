import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPessoaJuridica extends StatefulWidget {
  @override
  _CadastroPessoaJuridicaState createState() => _CadastroPessoaJuridicaState();
}

class _CadastroPessoaJuridicaState extends State<CadastroPessoaJuridica> {
  String nomeFantasia = '';
  String cnpj = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pessoa Jurídica'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nome Fantasia'),
            onChanged: (value) {
              setState(() {
                nomeFantasia = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'CNPJ'),
            onChanged: (value) {
              setState(() {
                cnpj = value;
              });
            },
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
    );
  }

  void salvarDados() {
    FirebaseFirestore.instance.collection('pessoa_juridica').add({
      'nomeFantasia': nomeFantasia,
      'cnpj': cnpj,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados salvos com sucesso')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados: $error')),
      );
    });
  }
}
