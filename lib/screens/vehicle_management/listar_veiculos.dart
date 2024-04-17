import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/cadastro_veiculo.dart';

import '../../widgets/custom_card_vehicle.dart';

class ListarVeiculosHandler extends StatefulWidget {

  const ListarVeiculosHandler({super.key});

  @override
  ListarVeiculos createState() => ListarVeiculos();
}

class ListarVeiculos extends State<ListarVeiculosHandler> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar veículos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
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
                SizedBox(
                  width: 16,
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_rounded,
                    size: 50,
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroVeiculo(
                          veiculo: {},
                        ),
                      ),
                    ),
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('veiculos').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var items = snapshot.data!.docs.where((element) =>
                    element['placa']
                        .toString()
                        .toLowerCase()
                        .contains(searchString));
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var veiculo = items.elementAt(index).data();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CadastroVeiculo(veiculo: veiculo),
                          ),
                        );
                      },
                      child: CustomCardVehicle(
                          veiculo['modelo'],
                          veiculo['anoFabricacao'],
                          veiculo['placa'],
                          veiculo['id']),
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
