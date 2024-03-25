import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/screens/person_management/cadastro_pessoa_fisica.dart';
import 'package:projeto_auto_locacao/screens/person_management/cadastro_pessoa_juridica.dart';
import 'package:projeto_auto_locacao/screens/person_management/listar_pessoas.dart';

class PersonManagement extends StatefulWidget {
  @override
  _PersonManagementState createState() => _PersonManagementState();
}

class _PersonManagementState extends State<PersonManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Pessoas'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _mostrarOpcoesPessoa(context);
                },
                child: Text('Cadastrar Pessoa'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaPessoas()),
                  );
                },
                child: Text('Ver Pessoas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _mostrarOpcoesPessoa(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Escolha o tipo de pessoa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroPessoaFisica()),
                );
              },
              child: Text('Pessoa Física'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroPessoaJuridica()),
                );
              },
              child: Text('Pessoa Jurídica'),
            ),
          ],
        ),
      );
    },
  );
}
