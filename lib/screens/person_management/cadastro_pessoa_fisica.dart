import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/models/pessoa_fisica.dart';
import 'package:uuid/uuid.dart';

class CadastroPessoaFisica extends StatefulWidget {
  const CadastroPessoaFisica({super.key});

  @override
  _CadastroPessoaFisicaState createState() {
    return _CadastroPessoaFisicaState();
  }
}

class _CadastroPessoaFisicaState extends State<CadastroPessoaFisica> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _estadoCivilController = TextEditingController();
  final TextEditingController _profissaoController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _dtNascimentoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Pessoa Física'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _cpfController,
            decoration: const InputDecoration(labelText: 'CPF'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'E-mail'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _enderecoController,
            decoration: const InputDecoration(labelText: 'Endereço'),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _estadoCivilController,
            decoration: const InputDecoration(labelText: 'Estado Civil'),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _profissaoController,
            decoration: const InputDecoration(labelText: 'Profissão'),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _sexoController,
            decoration: const InputDecoration(labelText: 'Sexo'),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _telefoneController,
            decoration: const InputDecoration(labelText: 'Telefone'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _dtNascimentoController,
            decoration: const InputDecoration(labelText: 'Data de Nascimento'),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              salvarDados();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    ));
  }

  void salvarDados() {
    PessoaFisica pessoaFisica = PessoaFisica(
        id: const Uuid().v1(),
        nome: _nomeController.text,
        cpf: _cpfController.text,
        email: _emailController.text,
        endereco: _enderecoController.text,
        estadoCivil: _estadoCivilController.text,
        profissao: _profissaoController.text,
        sexo: _sexoController.text,
        telefone: _telefoneController.text,
        dtNascimento: _dtNascimentoController.text);
    FirebaseFirestore.instance
        .collection('pessoa_fisica')
        .doc(pessoaFisica.id)
        .set(pessoaFisica.toMap())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados salvos com sucesso')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados: $error')),
      );
    });
  }
}
