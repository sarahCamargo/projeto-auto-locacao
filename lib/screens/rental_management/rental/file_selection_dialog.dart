import 'package:flutter/material.dart';

class FileSelectionDialog {
  static void show(BuildContext context, List<Map<String, String>> files, Function(Map<String, String>) onFileSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione um arquivo'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file['name'] ?? 'Arquivo sem nome'),
                  onTap: () {
                    Navigator.pop(context);
                    onFileSelected(file);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}