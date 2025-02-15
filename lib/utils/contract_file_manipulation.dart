import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:open_file/open_file.dart';
import 'package:projeto_auto_locacao/utils/contract_data.dart';
import 'package:xml/xml.dart';

import '../models/rental.dart';
import '../services/prefs_service.dart';

class ContractFileManipulation {
  Future<void> contractFileManipulation(Rental rental, selectedFile) async {
    final prefsService = PrefsService();
    final tempDir = await prefsService.getTempDirectory();
    final defaultFile = await prefsService.getDefaultFilePath();
    final outputDir = Directory('$tempDir/unzipped_docx');

    final data = ContractData().getData(rental);

    limparDiretorio(outputDir.path);

    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    final file = File(selectedFile['path']!);
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
      final result = await OpenFile.open(file2.path);
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
}
