import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCardVehicle extends StatelessWidget {

  final String modelo;
  final int ano;
  final String placa;

  const CustomCardVehicle(this.modelo, this.ano, this.placa);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(modelo, style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ano: " +  ano.toString()),
            Text("Placa: " + placa)
          ],
        ),
        leading: Icon(Icons.image_not_supported_outlined, size: 50,),
        trailing: Icon(Icons.delete),
      ),
    );
  }

}