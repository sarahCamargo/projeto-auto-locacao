import 'package:extenso/extenso.dart';
import 'package:intl/intl.dart';

import '../models/rental.dart';

class ContractData {
  Map<String, String?> getData(Rental rental) {
    double valor = parseValor(rental.paymentValue);
    String valorPorExtenso = convertDecimalToWords(valor);
    var person;
    var nomeAssinatura;
    if (rental.naturalPerson != null) {
      person = rental.naturalPerson;
      nomeAssinatura = rental.naturalPerson?.name?.toUpperCase();
    } else {
      nomeAssinatura = rental.legalPerson?.tradingName?.toUpperCase();
    }
    return {
      'nome': rental.naturalPerson?.name,
      'cpf': rental.naturalPerson?.cpf,
      'endereco':
      '${person?.street}, ${person?.addressNumber}, bairro ${person?.neighborhood}, ${person?.addressComplement}',
      'cidade': person.city,
      'cep': person.cep,
      'estado': person.state,
      'modelo': '${rental.vehicle?.brand}/${rental.vehicle?.model}',
      'ano': rental.vehicle?.year,
      'cor': rental.vehicle?.color,
      'placa': rental.vehicle?.licensePlate,
      'renavam': rental.vehicle?.renavam.toString(),
      'proprietario': rental.vehicle?.owner,
      'data': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'nomeAssinatura': nomeAssinatura,
      'valor': '${rental.paymentValue} ($valorPorExtenso)',
      'frequencia': getFrequencia(rental.paymentType),
      "cnpj": rental.legalPerson?.cnpj,
      "nomeFantasia": rental.legalPerson?.tradingName,
      "razaoSocial": rental.legalPerson?.companyName,
    };
  }

  double parseValor(String? valor) {
    final regex = RegExp(r'^R\$ ?');
    String? valorSemR = valor?.replaceAll(regex, '');

    valorSemR = valorSemR?.replaceAll('.', '').replaceAll(',', '.');
    return double.parse(valorSemR!);
  }

  String convertDecimalToWords(double numero) {
    return extenso(numero);
  }

  String getFrequencia(String? frequencia) {
    if (frequencia == 'Diário') {
      return 'dia';
    } else if (frequencia == 'Semanal') {
      return 'semana';
    } else if (frequencia == 'Mensal') {
      return 'mês';
    } else {
      return 'ano';
    }
  }
}