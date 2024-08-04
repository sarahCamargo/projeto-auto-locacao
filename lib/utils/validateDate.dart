import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

/*
void _validateDate(TextEditingController textEditingController) {
  String date = textEditingController.text;
  if (date.isNotEmpty) {
    String numericDate = date.replaceAll(RegExp(r'[^0-9]'), '');
    setState(() {
      try {
        DateTime parsedDate = DateTime.parse(
          '${numericDate.substring(4, 8)}-${numericDate.substring(2, 4)}-${numericDate.substring(0, 2)}',
        );
        if (_dateFormat.format(parsedDate) == date) {
          _birthDateError = null;
        }
      } catch (e) {
        _birthDateError = 'Data inválida. Use o formato dd/mm/aaaa.';
        _isSaveButtonEnabled = false;
      }
    });
  }
}
*/