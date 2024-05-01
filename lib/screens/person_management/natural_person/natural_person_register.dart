import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_auto_locacao/constants/collection_names.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/person_management_constants.dart';
import 'package:projeto_auto_locacao/models/natural_person.dart';
import 'package:projeto_auto_locacao/services/fetch_address_service.dart';
import 'package:projeto_auto_locacao/services/database/database_handler.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_form_field.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../../services/validation_service.dart';

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
      MaskedTextController(mask: PersonConstants.cepMask);
  final MaskedTextController _birthDateController =
      MaskedTextController(mask: PersonConstants.birthDateMask);
  final MaskedTextController _cpfController =
      MaskedTextController(mask: PersonConstants.cpfMask);
  final MaskedTextController _cellPhoneController =
      MaskedTextController(mask: PersonConstants.cellPhoneMask);

  @override
  void initState() {
    super.initState();
    _cpfController.addListener(_validateCPF);
    _birthDateController.addListener(_validateDate);
    if (widget.person["id"] != null) {
      _nameController.text = widget.person["name"];
      _cpfController.text = widget.person["cpf"].toString();
      _emailController.text = widget.person["email"];
      _selectedCivilStatus = widget.person["civilState"];
      _careerController.text = widget.person["career"];
      _sexController = widget.person["sex"];
      _cellPhoneController.text = widget.person["cellPhone"].toString();
      _birthDateController.text = widget.person["birthDate"];
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
    return Scaffold(
      appBar: const CustomAppBar(title: PersonConstants.appBarTitle),
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
                label: PersonConstants.personalData,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.nameLabel),
              CustomTextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                onChange: (value) {
                  _updateSaveButtonState(_nameController);
                },
                isRequired: true,
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.cpfLabel),
              CustomTextField(
                  maskedController: _cpfController,
                  keyboardType: TextInputType.number,
                  hintText: PersonConstants.cpfMask,
                  errorText: _cpfError,
                  onChange: (value) {
                    _updateSaveButtonState(_cpfController);
                  },
                  isRequired: true),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.birthDateLabel),
              CustomTextField(
                  maskedController: _birthDateController,
                  keyboardType: TextInputType.datetime,
                  errorText: _birthDateError,
                  hintText: PersonConstants.birthDateHint),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.sexLabel),
              Row(
                children: [
                  Radio(
                    value: PersonConstants.female,
                    groupValue: _sexController,
                    onChanged: (value) {
                      setState(() {
                        _sexController = value.toString();
                      });
                    },
                  ),
                  const Text(PersonConstants.female),
                  const SizedBox(width: 20.0),
                  Radio(
                    value: PersonConstants.male,
                    groupValue: _sexController,
                    onChanged: (value) {
                      setState(() {
                        _sexController = value.toString();
                      });
                    },
                  ),
                  const Text(PersonConstants.male),
                ],
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.emailLabel),
              CustomTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.civilStatusLabel),
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
                  items: PersonConstants.civilStatus.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: status == null
                          ? const Text(PersonConstants.doNotInform)
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
              const CustomTextLabel(label: PersonConstants.careerLabel),
              CustomTextField(
                  controller: _careerController,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.cellPhoneLabel),
              CustomTextField(
                  maskedController: _cellPhoneController,
                  keyboardType: TextInputType.phone,
                  hintText: PersonConstants.cellPhoneHint,
                  onChange: (value) {
                    _updateSaveButtonState(_cellPhoneController);
                  },
                  isRequired: true),
              const SizedBox(height: 20.0),
              const CustomTextLabel(
                  label: PersonConstants.addressData,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.cepLabel),
              CustomTextField(
                maskedController: _cepController,
                keyboardType: TextInputType.number,
                hintText: PersonConstants.cepMask,
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
                        hintText: PersonConstants.stateLabel,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: _cityController,
                          readOnly: true,
                          hintText: PersonConstants.cityLabel,
                        )),
                  ],
                ),
              ),
              const CustomTextLabel(label: PersonConstants.streetLabel),
              CustomTextField(
                  controller: _streetController, readOnly: !_isAddressEditable),
              //readOnly,
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.neighborhoodLabel),
              CustomTextField(
                  controller: _neighborhoodController,
                  readOnly: !_isAddressEditable),
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
                        hintText: PersonConstants.addressNumber,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: _addressComplementController,
                          readOnly: !_isAddressEditable,
                          hintText: PersonConstants.addressComplement,
                        )),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _isSaveButtonEnabled
                      ? () {
                          isCPFRegistered().then((isRegistered) {
                            if (isRegistered) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'CPF já cadastrado. Não é possível salvar.'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              saveData();
                            }
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsConstants.backgroundColor),
                  child: const CustomTextLabel(
                    label: PersonConstants.saveButton,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> isCPFRegistered() async {
    if (widget.person['id'] == null ||
        widget.person['cpf'] != _cpfController.text) {
      return await isCpfAlreadyRegistered(_cpfController.text);
    }
    return false;
  }

  void saveData() {
    NaturalPerson naturalPerson = NaturalPerson();
    naturalPerson.name = _nameController.text;
    naturalPerson.cpf = _cpfController.text;
    naturalPerson.email = _emailController.text;
    naturalPerson.civilState = _selectedCivilStatus;
    naturalPerson.career = _careerController.text;
    naturalPerson.sex = _sexController;
    naturalPerson.cellPhone = _cellPhoneController.text;
    naturalPerson.birthDate = _birthDateController.text;
    naturalPerson.cep = _cepController.text;
    naturalPerson.street = _streetController.text;
    naturalPerson.state = _stateController.text;
    naturalPerson.city = _cityController.text;
    naturalPerson.neighborhood = _neighborhoodController.text;
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
        _cpfError = PersonConstants.cpfErrorMessage;
        _isSaveButtonEnabled = false;
      } else {
        _cpfError = null;
      }
    });
  }
}
