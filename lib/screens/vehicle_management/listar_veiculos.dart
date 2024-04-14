import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/detalhes_veiculo.dart';

import '../../widgets/custom_card_vehicle.dart';

class ListarVeiculos extends StatefulWidget {
  @override
  _ListarVeiculos createState() => _ListarVeiculos();
}

class _ListarVeiculos extends State<ListarVeiculos> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Veículos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Pesquisar por placa',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('veiculos').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var items = snapshot.data!.docs.where((element) => element['placa'].toString().toLowerCase().contains(searchString));

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var veiculo = items.elementAt(index).data();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesVeiculoScreen(veiculo: veiculo),
                          ),
                        );
                      },
                      /*
                      child: ListTile(
                        title: Text('Placa: ${veiculo['placa'].toString()}'),
                        subtitle: Text('Modelo: ${veiculo['modelo'].toString()}'),
                      ),

                       */
                      child: CustomCardVehicle(veiculo['modelo'], int.parse(veiculo['ano_fabricacao']) , veiculo['placa']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}