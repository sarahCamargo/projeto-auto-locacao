import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaPessoas extends StatefulWidget {
  @override
  _ListaPessoasState createState() => _ListaPessoasState();
}

class _ListaPessoasState extends State<ListaPessoas> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pessoas'),
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
              stream: FirebaseFirestore.instance.collection('pessoa_fisica').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var items = snapshot.data!.docs.where((element) => element['nome'].toString().toLowerCase().contains(searchString));

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var pessoa = items.elementAt(index);
                    return ListTile(
                      title: Text(pessoa['nome']),
                      subtitle: Text('CPF: ${pessoa['cpf'].toString()}'),
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
