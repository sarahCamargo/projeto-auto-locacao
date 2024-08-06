import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class ContractConf extends StatefulWidget {
  const ContractConf({super.key});

  @override
  ContractConfState createState() => ContractConfState();
}

class ContractConfState extends State<ContractConf> {
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _loadFilePath();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
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
                    label: "Template Contrato para Pessoa Física:",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 24),
                  if (_filePath != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        initialValue: p.basename(_filePath!),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.trash,
                              color: ColorsConstants.iconColor,
                              size: 18,
                            ),
                            onPressed: _clearFile,
                          ),
                          labelText: 'Arquivo Selecionado',
                        ),
                      ),
                    ),
                  ] else ...[
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.squarePlus,
                          size: 48, color: ColorsConstants.iconColor),
                      onPressed: _pickFile,
                    ),
                    const SizedBox(height: 16),
                    const CustomTextLabel(
                      label: 'Escolher arquivo .docx',
                      fontSize: 16,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _filePath = prefs.getString('docx_file_path');
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        _saveFilePath(_filePath);
      });
    }
  }

  Future<void> _saveFilePath(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString('docx_file_path', path);
    }
  }

  Future<void> _clearFile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('docx_file_path');
    setState(() {
      _filePath = null;
    });
  }
}
