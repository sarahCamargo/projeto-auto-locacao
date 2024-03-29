import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/models/pessoa_fisica.dart';
import 'package:projeto_auto_locacao/screens/person_management/listar_pessoas.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_form_field.dart';

class CadastroPessoaFisica extends StatefulWidget {
  @override
  _CadastroPessoaFisicaState createState() => _CadastroPessoaFisicaState();

  final Map<String, dynamic> pessoa;

  const CadastroPessoaFisica({super.key, required this.pessoa});
}

class _CadastroPessoaFisicaState extends State<CadastroPessoaFisica> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _estadoCivilController = TextEditingController();
  final TextEditingController _profissaoController = TextEditingController();
  String _sexoController = '';

  final MaskedTextController _dtNascimentoController =
      MaskedTextController(mask: '00/00/0000');
  final MaskedTextController _cpfController =
      MaskedTextController(mask: '000.000.000-00');
  final MaskedTextController _telefoneController =
      MaskedTextController(mask: '(00) 00000-0000');

  @override
  void initState() {
    super.initState();
    if (widget.pessoa["id"] != null) {
      _nomeController.text = widget.pessoa["nome"];
      _cpfController.text = widget.pessoa["cpf"].toString();
      _emailController.text = widget.pessoa["email"];
      _enderecoController.text = widget.pessoa["endereco"];
      _estadoCivilController.text = widget.pessoa["estado_civil"];
      _profissaoController.text = widget.pessoa["profissao"];
      _sexoController = widget.pessoa["sexo"];
      _telefoneController.text = widget.pessoa["telefone"].toString();
      _dtNascimentoController.text = widget.pessoa["dtNascimento"];
    }
  }

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
          const Text(
            'Dados Pessoais',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18.0),
          const CustomTextLabel(label: 'Nome'),
          const SizedBox(height: 10.0),
          CustomTextField(
              controller: _nomeController, keyboardType: TextInputType.name),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _cpfController,
            decoration: const InputDecoration(
                labelText: 'CPF', hintText: '000.000.000-00'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _dtNascimentoController,
            decoration: const InputDecoration(
              labelText: 'Data de Nascimento',
              hintText: 'dd/mm/aaaa',
            ),
            keyboardType: TextInputType.datetime,
            onChanged: (value) {
              if (value.isEmpty) {
                _dtNascimentoController.updateText('dd/mm/aaaa');
              }
            },
          ),
          const SizedBox(height: 20.0),
          const CustomTextLabel(label: 'Sexo'),
          Row(
            children: [
              Radio(
                value: 'Feminino',
                groupValue: _sexoController,
                onChanged: (value) {
                  setState(() {
                    _sexoController = value.toString();
                  });
                },
              ),
              Text('Feminino'),
              SizedBox(width: 20.0),
              Radio(
                value: 'Masculino',
                groupValue: _sexoController,
                onChanged: (value) {
                  setState(() {
                    _sexoController = value.toString();
                  });
                },
              ),
              Text('Masculino'),
            ],
          ),
          const SizedBox(height: 16.0),
          const CustomTextLabel(label: 'E-mail'),
          CustomTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),
          const CustomTextLabel(label: 'Estado Civil'),
          CustomTextField(
              controller: _estadoCivilController,
              keyboardType: TextInputType.text),
          const SizedBox(height: 16.0),
          const CustomTextLabel(label: 'Profissão'),
          CustomTextField(
              controller: _profissaoController,
              keyboardType: TextInputType.text),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _telefoneController,
            decoration: const InputDecoration(labelText: 'Telefone'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _enderecoController,
            decoration: const InputDecoration(labelText: 'Endereço'),
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
    if (widget.pessoa["id"] == null) {
      PessoaFisica pessoaFisica = PessoaFisica(
          id: const Uuid().v1(),
          nome: _nomeController.text,
          cpf: _cpfController.text,
          email: _emailController.text,
          endereco: _enderecoController.text,
          estadoCivil: _estadoCivilController.text,
          profissao: _profissaoController.text,
          sexo: _sexoController,
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
    } else {
      FirebaseFirestore.instance
          .collection('pessoa_fisica')
          .doc(widget.pessoa["id"])
          .update({
        "nome": _nomeController.text,
        "cpf": _cpfController.text,
        "email": _emailController.text,
        "endereco": _enderecoController.text,
        "estadoCivil": _estadoCivilController.text,
        "profissao": _profissaoController.text,
        "sexo": _sexoController,
        "telefone": _telefoneController.text,
        "dtNascimento": _dtNascimentoController.text
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados salvos com sucesso')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListaPessoas()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados: $error')),
        );
      });
    }
  }
}
