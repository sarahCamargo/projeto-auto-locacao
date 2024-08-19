import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:extenso/extenso.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:xml/xml.dart';

import '../models/rental.dart';
import '../services/prefs_service.dart';

class ContractFileManipulation {
  Future<void> contractFileManipulation(Rental rental) async {
    final prefsService = PrefsService();
    final filePath = await prefsService.getFilePath();
    final tempDir = await prefsService.getTempDirectory();
    final defaultFile = await prefsService.getDefaultFilePath();
    final outputDir = Directory('$tempDir/unzipped_docx');

    final data = getData(rental);

    limparDiretorio(outputDir.path);

    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    final file = File(filePath!);
    final bytes = await file.readAsBytes();

    final archive = ZipDecoder().decodeBytes(bytes);

    final contentFile = archive.findFile('content.xml');
    if (contentFile == null) {
      throw Exception('Arquivo content.xml não encontrado');
    }

    final content = utf8.decode(contentFile.content as List<int>);

    final newContent = _replacePlaceholders(content, data);

    final newContentFile = ArchiveFile(
        'content.xml', utf8.encode(newContent).length, utf8.encode(newContent));

    final newArchive = Archive();
    for (var file in archive.files) {
      if (file.name == 'content.xml') {
        newArchive.addFile(newContentFile);
      } else {
        newArchive.addFile(file);
      }
    }

    final output = ZipEncoder().encode(newArchive);
    final newDocxPath = '$defaultFile/contrato-locacao-${rental.id}.odt';
    await File(newDocxPath).writeAsBytes(output!);

    final file2 = File(newDocxPath);

    if (await file2.exists()) {
      final result = await OpenFilex.open(file2.path);
      if (result.type == ResultType.error) {
        print('Erro ao abrir o arquivo: ${result.message}');
      }
    } else {
      print('O arquivo ODT não foi encontrado.');
    }
  }

  String _replacePlaceholders(
      String content, Map<String, String?> replacements) {
    return replacements.entries.fold(content, (acc, entry) {
      final regex = RegExp('\\{${entry.key}\\}');
      return acc.replaceAll(regex, entry.value ?? '');
    });
  }

  void limparDiretorio(String caminhoDoDiretorio) async {
    final directory = Directory(caminhoDoDiretorio);

    try {
      await directory.delete(recursive: true);
      print('Diretório $caminhoDoDiretorio limpo com sucesso.');
    } catch (e) {
      print('Erro ao limpar o diretório: $e');
    }
  }

  Future<void> modifyXmlContent(
      String xmlFilePath, Map<String, String> data) async {
    final file = File(xmlFilePath);
    final xmlContent =
        await file.readAsString(encoding: utf8);

    final document = XmlDocument.parse(xmlContent);

    data.forEach((key, value) {
      document.findAllElements('w:t').forEach((element) {
        if (element.innerText.contains('{{${key}}}')) {
          element.innerText = element.innerText.replaceAll('{{$key}}', value);
        }
      });
    });

    await file.writeAsString(document.toXmlString(pretty: true, indent: '  '),
        encoding: utf8);
  }

  Map<String, String?> getData(Rental rental) {
    double valor = parseValor(rental.paymentValue);
    String valorPorExtenso = convertDecimalToWords(valor);
    return {
      'nome': rental.naturalPerson?.name,
      'cpf': rental.naturalPerson?.cpf,
      'endereco':
          '${rental.naturalPerson?.street}, ${rental.naturalPerson?.addressNumber}, bairro ${rental.naturalPerson?.neighborhood}, ${rental.naturalPerson?.addressComplement}',
      'cidade': rental.naturalPerson?.city,
      'cep': rental.naturalPerson?.cep,
      'estado': rental.naturalPerson?.state,
      'modelo': '${rental.vehicle?.brand}/${rental.vehicle?.model}',
      'ano': rental.vehicle?.year,
      'cor': rental.vehicle?.color,
      'placa': rental.vehicle?.licensePlate,
      'renavam': rental.vehicle?.renavam.toString(),
      'proprietario': rental.vehicle?.owner,
      'data': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'nomeAssinatura': rental.naturalPerson?.name?.toUpperCase(),
      'valor': '${rental.paymentValue} ($valorPorExtenso)',
      'frequencia': getFrequencia(rental.paymentType)
    };
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

  double parseValor(String? valor) {
    final regex = RegExp(r'^R\$ ?');
    String? valorSemR = valor?.replaceAll(regex, '');

    valorSemR = valorSemR?.replaceAll('.', '').replaceAll(',', '.');
    return double.parse(valorSemR!);
  }

  String convertDecimalToWords(double numero) {
    return extenso(numero);
  }
}
