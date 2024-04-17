import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/listar_veiculos.dart';

import 'cadastro_veiculo.dart';

class GerenciarVeiculo extends StatefulWidget {
  @override
  _GerenciarVeiculo createState() => _GerenciarVeiculo();
}

class _GerenciarVeiculo extends State<GerenciarVeiculo> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Escolha a ação'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CadastroVeiculo(veiculo: {})),
                      );
                    },
                    child: Text('Cadastrar veículo'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListarVeiculosHandler()),
                      );
                    },
                    child: Text('Listar veículo'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Text('Gerenciar Veículos'),
    );
  }
}