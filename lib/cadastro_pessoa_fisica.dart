import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPessoaFisica extends StatefulWidget {
  @override
  _CadastroPessoaFisicaState createState() => _CadastroPessoaFisicaState();
}

class _CadastroPessoaFisicaState extends State<CadastroPessoaFisica> {
  String nome = '';
  String cpf = '';
  String email = '';
  String endereco = '';
  String estado_civil = '';
  String profissao = '';
  String sexo = '';
  String telefone = '';
  String dtNascimento = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pessoa Física'),
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
            decoration: InputDecoration(labelText: 'Nome'),
            keyboardType: TextInputType.name,
            onChanged: (value) {
              setState(() {
                nome = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'CPF'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                cpf = value;
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
            onChanged: (value) {
              setState(() {
                endereco = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Estado Civil'),
            onChanged: (value) {
              setState(() {
                estado_civil = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Profissão'),
            onChanged: (value) {
              setState(() {
                profissao = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Sexo'),
            onChanged: (value) {
              setState(() {
                sexo = value;
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
            decoration: InputDecoration(labelText: 'Data de Nascimento'),
            keyboardType: TextInputType.datetime,
            onChanged: (value) {
              setState(() {
                dtNascimento = value;
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
    FirebaseFirestore.instance.collection('pessoa_fisica').add({
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'endereco': endereco,
      'estado_civil': estado_civil,
      'profissao': profissao,
      'sexo': sexo,
      'telefone': telefone,
      'dt_nascimento': dtNascimento
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
