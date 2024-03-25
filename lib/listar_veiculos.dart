import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                    var veiculos = items.elementAt(index);
                    return ListTile(
                      title: Text('Placa: ${veiculos['placa'].toString()}'),
                      subtitle: Text('Modelo: ${veiculos['modelo'].toString()}'),
                      // Mais detalhes ou ações para exibir aqui
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