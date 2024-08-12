import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:projeto_auto_locacao/constants/maintenance_management_constants.dart';
import 'package:projeto_auto_locacao/services/notification_service.dart';
import 'package:provider/provider.dart';

import '../../../constants/collection_names.dart';
import '../../../constants/colors_constants.dart';
import '../../../constants/general_constants.dart';
import '../../../constants/person_management_constants.dart';
import '../../../models/maintenance.dart';
import '../../../services/database/database_handler.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custom_text_label.dart';

class MaintenanceRegister extends StatefulWidget {
  @override
  MaintenanceRegisterState createState() => MaintenanceRegisterState();

  final int idVehicle;
  final Map<String, dynamic> maintenance;

  const MaintenanceRegister(
      {super.key, required this.idVehicle, required this.maintenance});
}

class MaintenanceRegisterState extends State<MaintenanceRegister> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.maintenance);

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  String? _dateError;
  String? _selectedTipo;
  int? _selectedFrequencia;
  final TextEditingController _outroController = TextEditingController();
  final MaskedTextController _ultimaVerificacaoController =
      MaskedTextController(mask: '00/00/0000');
  final MaskedTextController _proximaVerificacaoController =
      MaskedTextController(mask: '00/00/0000');

  bool _isSaveButtonEnabled = true;

  @override
  void initState() {
    super.initState();

    if (widget.maintenance['id'] != null) {
      _selectedTipo = widget.maintenance['type'];
      _outroController.text = widget.maintenance['other'];
      if (widget.maintenance['frequency'] != null) {
        _selectedFrequencia = int.parse(widget.maintenance['frequency']);
      }
      _ultimaVerificacaoController.text = widget.maintenance['lastCheck'];
      _proximaVerificacaoController.text = widget.maintenance['nextCheck'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: MaintenanceConstants.appBarTitle),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16.0),
              const CustomTextLabel(
                label: MaintenanceConstants.maintenanceData,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextLabel(
                          label: MaintenanceConstants.typeLabel,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButtonFormField<String>(
                            value: _selectedTipo,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: MaintenanceConstants.type.map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: status == null
                                    ? const Text(GeneralConstants.doNotInform)
                                    : Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTipo = value;
                                if (_selectedTipo != 'Outro') {
                                  _outroController.text = '';
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              Visibility(
                visible: _selectedTipo == 'Outro',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextLabel(
                      label: MaintenanceConstants.otherLabel,
                    ),
                    CustomTextField(
                      controller: _outroController,
                      keyboardType: TextInputType.name,
                      isRequired: false,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextLabel(
                          label: MaintenanceConstants.frequencyLabel,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButtonFormField<int>(
                            value: _selectedFrequencia,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: MaintenanceConstants.frequency.entries
                                .map((status) {
                              return DropdownMenuItem<int>(
                                value: status.key,
                                child: Text(status.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedFrequencia = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextLabel(
                          label: MaintenanceConstants.lastCheckLabel,
                        ),
                        CustomTextField(
                          maskedController: _ultimaVerificacaoController,
                          keyboardType: TextInputType.datetime,
                          hintText: PersonConstants.birthDateHint,
                          isRequired: false,
                          errorText: _dateError,
                          onChange: (value) {
                            _calcNextFrequency();
                          },
                        )
                      ],
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextLabel(
                          label: MaintenanceConstants.nextCheckLabel,
                        ),
                        CustomTextField(
                          maskedController: _proximaVerificacaoController,
                          keyboardType: TextInputType.datetime,
                          hintText: PersonConstants.birthDateHint,
                          isRequired: false,
                          errorText: _dateError,
                          onChange: (value) {
                            _validateDate(_proximaVerificacaoController);
                          },
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: _isSaveButtonEnabled
                      ? () {
                          save();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsConstants.backgroundColor),
                  child: const CustomTextLabel(
                    label: GeneralConstants.saveButton,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _checkButtonStatus() {
    setState(() {
      _isSaveButtonEnabled = _selectedTipo.toString().isNotEmpty &&
          _selectedFrequencia.toString().isNotEmpty &&
          _ultimaVerificacaoController.text.isNotEmpty &&
          _proximaVerificacaoController.text.isNotEmpty;
    });
  }

  void _updateSaveButtonState(TextEditingController textEditingController) {
    setState(() {
      _isSaveButtonEnabled = textEditingController.text.isNotEmpty;
    });
  }

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
            _dateError = null;
          }
        } catch (e) {
          _dateError = 'Data inválida. Use o formato dd/mm/aaaa.';
        }
      });
    }
  }

  void _calcNextFrequency() {
    _validateDate(_ultimaVerificacaoController);
    if (_dateError == null) {
      String date = _ultimaVerificacaoController.text;
      String numericDate = date.replaceAll(RegExp(r'[^0-9]'), '');
      DateTime parsedDate = DateTime.parse(
        '${numericDate.substring(4, 8)}-${numericDate.substring(2, 4)}-${numericDate.substring(0, 2)}',
      );

      if (MaintenanceConstants.frequencyDurations
          .containsKey(_selectedFrequencia)) {
        parsedDate = parsedDate
            .add(MaintenanceConstants.frequencyDurations[_selectedFrequencia]!);
      }

      _proximaVerificacaoController.text = _dateFormat.format(parsedDate);
    }
  }

  void save() {
    if (_selectedTipo == null || _selectedTipo!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o tipo'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_selectedTipo == 'Outro' && _outroController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o campo Outro'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_selectedTipo != 'Outro' && _outroController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não informe o campo Outro'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    saveData().then((maintenance) {
      dbHandler.save(context, widget.maintenance['id'], maintenance);
    });

    Provider.of<NotificationService>(context, listen: false).showNotification(
        CustomNotification(
            id: 1, title: 'Teste', body: 'Acesse o app', payload: '/aa'));
  }

  Future<Maintenance> saveData() async {
    Maintenance maintenance = Maintenance();
    maintenance.idVehicle = widget.idVehicle;
    maintenance.type = _selectedTipo;
    maintenance.other = _outroController.text;
    maintenance.frequency = _selectedFrequencia;
    maintenance.lastCheck = _ultimaVerificacaoController.text;
    maintenance.nextCheck = _proximaVerificacaoController.text;

    return maintenance;
  }
}
