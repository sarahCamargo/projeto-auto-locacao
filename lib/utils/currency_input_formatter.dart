import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _currencyFormatter = NumberFormat.compactCurrency(locale: 'pt', symbol: 'R\$' );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final value = double.tryParse(text.replaceAll(RegExp(r'\D'), ''));
    final formattedValue = value != null
        ? _currencyFormatter.format(value / 100)
        : '';

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}