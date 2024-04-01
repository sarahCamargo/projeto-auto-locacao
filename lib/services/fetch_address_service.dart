import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FetchAddressService {

  final logger = Logger();

  Future<Map<String, dynamic>?> fetchAddress(String cep) async {
    cep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length == 8) {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to fetch address');
        }
      } catch (e) {
        logger.e('Error', error: e);
      }
    }
    return null;
  }
}