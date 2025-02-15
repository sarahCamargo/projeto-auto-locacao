import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/configuration_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';

import '../../services/prefs_service.dart';
import '../../utils/show_snackbar.dart';
import '../../widgets/text/custom_text_label.dart';

class ContractConf extends StatefulWidget {
  const ContractConf({super.key});

  @override
  ContractConfState createState() => ContractConfState();
}

class ContractConfState extends State<ContractConf> {
  List<Map<String, String>> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomTextLabel(
                    label: ConfigurationConstants.contractTemplates,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 24),
                  ..._files.map((file) => _buildFileTile(file)),
                  TextButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(FontAwesomeIcons.plus,
                        size: 18, color: ColorsConstants.blueFields),
                    label: const Text(ConfigurationConstants.addFile,
                        style: TextStyle(color: ColorsConstants.blueFields)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileTile(Map<String, String> file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: file['name'],
              onChanged: (value) => _updateFileName(file['path']!, value),
              decoration: InputDecoration(
                labelText: ConfigurationConstants.fileName,
                labelStyle: const TextStyle(color: Colors.black54),
                hintText: ConfigurationConstants.insetFileName,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.black45, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.trash,
              color: ColorsConstants.iconColor,
              size: 20,
            ),
            onPressed: () => _removeFile(file['path']!),
          ),
        ],
      ),
    );
  }

  Future<void> _loadFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final filesString = prefs.getString('files');
    if (filesString != null) {
      setState(() {
        _files = (json.decode(filesString) as List)
            .map((file) => Map<String, String>.from(file as Map))
            .toList();
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['odt'],
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final prefsService = PrefsService();

      final internalPath =
          await prefsService.saveFileToInternalStorage(filePath);

      final newFile = {
        'path': internalPath,
        'name': p.basename(filePath),
      };

      setState(() {
        _files.add(newFile);
        _saveFiles();
        showCustomSnackBar(context, ConfigurationConstants.fileAdded);
      });
    } else {
      showCustomSnackBar(context, ConfigurationConstants.noFile);
    }
  }

  Future<void> _saveFiles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('files', json.encode(_files));
  }

  void _updateFileName(String path, String newName) {
    setState(() {
      final file = _files.firstWhere((file) => file['path'] == path);
      file['name'] = newName;
      _saveFiles();
    });
  }

  Future<void> _removeFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
    setState(() {
      _files.removeWhere((file) => file['path'] == path);
      _saveFiles();
    });
    showCustomSnackBar(context, ConfigurationConstants.fileRemoved);
  }
}
