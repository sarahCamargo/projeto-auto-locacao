import 'package:flutter/material.dart';

class CustomModalFilters extends StatefulWidget {
  final Widget content;
  final Function() clearFilters;

  const CustomModalFilters({
    super.key,
    required this.content,
    required this.clearFilters
  });

  @override
  CustomModalFiltersState createState() => CustomModalFiltersState();
}

class CustomModalFiltersState extends State<CustomModalFilters> {
  void _closeModal() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filtros'),
      //content: widget.content,
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [widget.content],
              ),
            ))
          ],
        ),
      ),
      actions: [
        Row(children: [
          TextButton(
            onPressed: () {
              widget.clearFilters();
              _closeModal();
            },
            child: Text('Limpar'),),
          TextButton(
            onPressed: _closeModal,
            child: Text('Fechar'),
          )
        ],)

      ],
    );
  }
}