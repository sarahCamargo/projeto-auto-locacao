import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/services/veiculo_service.dart';

class CustomCardVehicle extends StatelessWidget {

  final String modelo;
  final int ano;
  final String placa;
  final String id;

  const CustomCardVehicle(this.modelo, this.ano, this.placa, this.id);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(modelo, style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ano: " + ano.toString()),
            Text("Placa: " + placa)
          ],
        ),
        leading: Icon(Icons.image_not_supported_outlined, size: 50,),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => {
          VeiculoService.deletaVeiculo(id).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veiculo deletado com sucesso')),
          );
          }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar veiculo: $error')),
          );
          })
        },
        ),
      ),
    );
  }

}