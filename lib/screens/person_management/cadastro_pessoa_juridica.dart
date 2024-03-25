import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPessoaJuridica extends StatefulWidget {
  @override
  _CadastroPessoaJuridicaState createState() => _CadastroPessoaJuridicaState();
}

class _CadastroPessoaJuridicaState extends State<CadastroPessoaJuridica> {
  String cnpj = '';
  String email = '';
  String endereco = '';
  String nomeFantasia = '';
  String porte = '';
  String razao_social = '';
  String responsavel_legal = '';
  String segmento = '';
  String telefone = '';

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
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'CNPJ'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cnpj = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Endereço'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    endereco = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
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
                decoration: InputDecoration(labelText: 'Porte'),
                onChanged: (value) {
                  setState(() {
                    porte = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Razão Social'),
                onChanged: (value) {
                  setState(() {
                    razao_social = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Responsável Legal'),
                onChanged: (value) {
                  setState(() {
                    responsavel_legal = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    telefone = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Segmento'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    segmento = value;
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
        ));
  }

  void salvarDados() {
    FirebaseFirestore.instance.collection('pessoa_juridica').add({
      'cnpj': cnpj,
      'email': email,
      'endereco': endereco,
      'nome_fantasia': nomeFantasia,
      'porte': porte,
      'razao_social': razao_social,
      'responsavel_legal': responsavel_legal,
      'segmento': segmento,
      'telefone': telefone
    }).then((value) {
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
}
