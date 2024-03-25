import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/screens/person_management/cadastro_pessoa_fisica.dart';
import 'package:projeto_auto_locacao/screens/person_management/cadastro_pessoa_juridica.dart';

class PersonManagement extends StatefulWidget {
  @override
  _PersonManagementState createState() => _PersonManagementState();
}

class _PersonManagementState extends State<PersonManagement> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _mostrarOpcoesPessoa(context);
      },
      child: Text('Gerenciar Pessoas'),
    );
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
                    MaterialPageRoute(builder: (context) => CadastroPessoaFisica()),
                  );
                },
                child: Text('Pessoa Física'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroPessoaJuridica()),
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
}