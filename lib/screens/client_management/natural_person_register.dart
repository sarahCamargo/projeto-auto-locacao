import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_auto_locacao/constants/collection_names.dart';
import 'package:projeto_auto_locacao/constants/client_constants.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/models/natural_person.dart';
import 'package:projeto_auto_locacao/services/fetch_address_service.dart';
import 'package:projeto_auto_locacao/services/database/database_handler.dart';
import 'package:projeto_auto_locacao/utils/show_snackbar.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:projeto_auto_locacao/widgets/text/custom_text_form_field.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../services/validation_service.dart';
import '../../widgets/buttons/register_save_button.dart';
import '../../widgets/text/register_text_label.dart';

class NaturalPersonRegister extends StatefulWidget {
  @override
  NaturalPersonRegisterState createState() => NaturalPersonRegisterState();
  final Map<String, dynamic> person;

  const NaturalPersonRegister({super.key, required this.person});
}

class NaturalPersonRegisterState extends State<NaturalPersonRegister> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.naturalPerson);
  String? _cpfError;
  String? _birthDateError;
  String? _selectedCivilStatus;
  String _sexController = '';
  bool _isAddressEditable = false;
  bool _isSaveButtonEnabled = false;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _addressNumberController =
      TextEditingController();
  final TextEditingController _addressComplementController =
      TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _careerController = TextEditingController();

  final MaskedTextController _cepController =
      MaskedTextController(mask: ClientConstants.cepMask);
  final MaskedTextController _birthDateController =
      MaskedTextController(mask: ClientConstants.birthDateMask);
  final MaskedTextController _cpfController =
      MaskedTextController(mask: ClientConstants.cpfMask);
  final MaskedTextController _cellPhoneController =
      MaskedTextController(mask: ClientConstants.cellPhoneMask);

  @override
  void initState() {
    super.initState();
    _cpfController.addListener(_validateCPF);
    _birthDateController.addListener(_validateDate);
    if (widget.person["id"] != null) {
      _nameController.text = widget.person["name"];
      _cpfController.text = widget.person["cpf"].toString();
      _emailController.text = widget.person["email"]?.toString() ?? '';
      _selectedCivilStatus = widget.person["civilState"];
      _careerController.text = widget.person["career"]?.toString() ?? '';
      _sexController = widget.person["sex"]?.toString() ?? '';
      _cellPhoneController.text = widget.person["cellPhone"].toString();
      _birthDateController.text = widget.person["birthDate"]?.toString() ?? '';
      if (widget.person["cep"] != null) {
        _isAddressEditable = true;
        _cepController.text = widget.person["cep"];
        _stateController.text = widget.person["state"];
        _cityController.text = widget.person["city"];
        _streetController.text = widget.person["street"];
        _neighborhoodController.text = widget.person["neighborhood"];
        _addressComplementController.text = widget.person["addressComplement"];
        if (widget.person["addressNumber"] != null) {
          _addressNumberController.text =
              widget.person["addressNumber"].toString();
        }
      }
    }
    _nameController.addListener(_checkButtonStatus);
    _cpfController.addListener(_checkButtonStatus);
    _emailController.addListener(_checkButtonStatus);
    _cellPhoneController.addListener(_checkButtonStatus);
    _checkButtonStatus();
  }

  @override
  void dispose() {
    _cpfController.removeListener(_validateCPF);
    _birthDateController.removeListener(_validateDate);
    _nameController.removeListener(_checkButtonStatus);
    _cpfController.removeListener(_checkButtonStatus);
    _emailController.removeListener(_checkButtonStatus);
    _cellPhoneController.removeListener(_checkButtonStatus);
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 16.0),
        const RegisterTextLabel(
          label: ClientConstants.personalData,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.nameLabel),
        CustomTextField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          onChange: (value) {
            _updateSaveButtonState(_nameController);
          },
          isRequired: true,
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.cpfLabel),
        CustomTextField(
            maskedController: _cpfController,
            keyboardType: TextInputType.number,
            hintText: ClientConstants.cpfMask,
            errorText: _cpfError,
            onChange: (value) {
              _updateSaveButtonState(_cpfController);
            },
            isRequired: true),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.birthDateLabel),
        CustomTextField(
            maskedController: _birthDateController,
            keyboardType: TextInputType.datetime,
            errorText: _birthDateError,
            hintText: ClientConstants.birthDateHint),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.sexLabel),
        Row(
          children: [
            Radio(
              value: ClientConstants.female,
              groupValue: _sexController,
              onChanged: (value) {
                setState(() {
                  _sexController = value.toString();
                });
              },
            ),
            const Text(ClientConstants.female),
            const SizedBox(width: 20.0),
            Radio(
              value: ClientConstants.male,
              groupValue: _sexController,
              onChanged: (value) {
                setState(() {
                  _sexController = value.toString();
                });
              },
            ),
            const Text(ClientConstants.male),
          ],
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.emailLabel),
        CustomTextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.civilStatusLabel),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: DropdownButtonFormField<String>(
            value: _selectedCivilStatus,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: ClientConstants.civilStatus.map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: status == null
                    ? const Text(GeneralConstants.doNotInform)
                    : Text(status),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCivilStatus = value;
              });
            },
          ),
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.careerLabel),
        CustomTextField(
            controller: _careerController, keyboardType: TextInputType.text),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.cellPhoneLabel),
        CustomTextField(
            maskedController: _cellPhoneController,
            keyboardType: TextInputType.phone,
            hintText: ClientConstants.cellPhoneHint,
            onChange: (value) {
              _updateSaveButtonState(_cellPhoneController);
            },
            isRequired: true),
        const SizedBox(height: 20.0),
        const RegisterTextLabel(
            label: ClientConstants.addressData, fontWeight: FontWeight.bold),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.cepLabel),
        CustomTextField(
          maskedController: _cepController,
          keyboardType: TextInputType.number,
          hintText: ClientConstants.cepMask,
          onChange: (value) {
            _fetchAddress(value);
          },
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: CustomTextField(
                  controller: _stateController,
                  readOnly: true,
                  hintText: ClientConstants.stateLabel,
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                  flex: 2,
                  child: CustomTextField(
                    controller: _cityController,
                    readOnly: true,
                    hintText: ClientConstants.cityLabel,
                  )),
            ],
          ),
        ),
        const RegisterTextLabel(label: ClientConstants.streetLabel),
        CustomTextField(
            controller: _streetController, readOnly: !_isAddressEditable),
        //readOnly,
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.neighborhoodLabel),
        CustomTextField(
            controller: _neighborhoodController, readOnly: !_isAddressEditable),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: CustomTextField(
                  controller: _addressNumberController,
                  readOnly: !_isAddressEditable,
                  hintText: ClientConstants.addressNumber,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                  flex: 2,
                  child: CustomTextField(
                    controller: _addressComplementController,
                    readOnly: !_isAddressEditable,
                    hintText: ClientConstants.addressComplement,
                  )),
            ],
          ),
        ),
        RegisterSaveButton(onPressed: pressSave(context)),
        const SizedBox(height: 16.0),
      ],
    );
  }

  pressSave(BuildContext context) {
    if (_isSaveButtonEnabled) {
      return () {
        isCPFRegistered().then((isRegistered) {
          if (isRegistered) {
            showCustomSnackBar(context, ClientConstants.cpfAlreadyRegistered);
          } else {
            saveData();
          }
        });
      };
    }
    return () => {};
  }

  Future<bool> isCPFRegistered() async {
    if (widget.person['id'] == null ||
        widget.person['cpf'] != _cpfController.text) {
      return await isCpfAlreadyRegistered(_cpfController.text);
    }
    return false;
  }

  void saveData() {
    NaturalPerson naturalPerson = NaturalPerson(
        name: _nameController.text,
        cpf: _cpfController.text,
        email: _emailController.text,
        civilState: _selectedCivilStatus,
        career: _careerController.text,
        sex: _sexController,
        cellPhone: _cellPhoneController.text,
        birthDate: _birthDateController.text,
        cep: _cepController.text,
        street: _streetController.text,
        state: _stateController.text,
        city: _cityController.text,
        neighborhood: _neighborhoodController.text);
    if (_addressNumberController.text.isNotEmpty) {
      naturalPerson.addressNumber = int.parse(_addressNumberController.text);
    }
    naturalPerson.addressComplement = _addressComplementController.text;
    dbHandler.save(context, widget.person["id"], naturalPerson);
  }

  Future<void> _fetchAddress(String cep) async {
    final data = await FetchAddressService().fetchAddress(cep);
    if (data != null && data['erro'] == null) {
      setState(() {
        _streetController.text = data['logradouro'];
        _neighborhoodController.text = data['bairro'];
        _stateController.text = data['uf'];
        _cityController.text = data['localidade'];
        _isAddressEditable = true;
      });
    } else {
      setState(() {
        _streetController.text = '';
        _neighborhoodController.text = '';
        _stateController.text = '';
        _cityController.text = '';
        _addressNumberController.text = '';
        _addressComplementController.text = '';
        _isAddressEditable = false;
      });
    }
  }

  void _checkButtonStatus() {
    setState(() {
      _isSaveButtonEnabled = _nameController.text.isNotEmpty &&
          _cpfController.text.isNotEmpty &&
          _cellPhoneController.text.isNotEmpty &&
          _cpfError == null &&
          _birthDateError == null;
    });
  }

  void _updateSaveButtonState(TextEditingController textEditingController) {
    setState(() {
      _isSaveButtonEnabled = textEditingController.text.isNotEmpty &&
          _cpfError == null &&
          _birthDateError == null;
    });
  }

  void _validateDate() {
    String birthDate = _birthDateController.text;
    if (birthDate.isNotEmpty) {
      String numericDate = birthDate.replaceAll(RegExp(r'[^0-9]'), '');
      setState(() {
        try {
          DateTime parsedDate = DateTime.parse(
            '${numericDate.substring(4, 8)}-${numericDate.substring(2, 4)}-${numericDate.substring(0, 2)}',
          );
          if (_dateFormat.format(parsedDate) == birthDate) {
            _birthDateError = null;
          }
        } catch (e) {
          _birthDateError = 'Data inválida. Use o formato dd/mm/aaaa.';
          _isSaveButtonEnabled = false;
        }
      });
    }
  }

  void _validateCPF() {
    setState(() {
      if (_cpfController.text.isNotEmpty &&
          !CPFValidator.isValid(_cpfController.text)) {
        _cpfError = ClientConstants.cpfErrorMessage;
        _isSaveButtonEnabled = false;
      } else {
        _cpfError = null;
      }
    });
  }
}
