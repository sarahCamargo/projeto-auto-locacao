import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/detalhes_veiculo.dart';

class ListarPessoasJuridicas extends StatefulWidget {
  @override
  _ListarPessoasJuridicas createState() => _ListarPessoasJuridicas();
}

class _ListarPessoasJuridicas extends State<ListarPessoasJuridicas> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pessoas jurídicas'),
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
                labelText: 'Pesquisar por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('pessoa_juridica').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();

                }

                var items = snapshot.data!.docs.where((element) => element['nome'].toString().toLowerCase().contains(searchString));

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var pessoa = items.elementAt(index).data(); // Acesse os dados do documento

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesVeiculoScreen(veiculo: pessoa),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text('Nome: ${pessoa['nome'].toString()}'),
                        subtitle: Text('Modelo: ${pessoa['modelo'].toString()}'),
                        // Mais detalhes ou ações para exibir aqui
                      ),
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