import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/constants/person_management_constants.dart';
import 'package:projeto_auto_locacao/models/natural_person.dart';
import 'package:projeto_auto_locacao/services/fetch_address_service.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_form_field.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../services/dao_service.dart';

class NaturalPersonRegister extends StatefulWidget {
  @override
  NaturalPersonRegisterState createState() => NaturalPersonRegisterState();

  final Map<String, dynamic> person;

  const NaturalPersonRegister({super.key, required this.person});
}

class NaturalPersonRegisterState extends State<NaturalPersonRegister> {
  String? _cpfError;
  String? _selectedCivilStatus;
  String _sexController = '';
  bool _isAddressEditable = false;
  bool _isSaveButtonEnabled = false;

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
    if (widget.person["id"] != null) {
      _nameController.text = widget.person["nome"];
      _cpfController.text = widget.person["cpf"].toString();
      _emailController.text = widget.person["email"];
      _selectedCivilStatus = widget.person["estado_civil"];
      _careerController.text = widget.person["profissao"];
      _sexController = widget.person["sexo"];
      _cellPhoneController.text = widget.person["telefone"].toString();
      _birthDateController.text = widget.person["dtNascimento"];
      _cepController.text = widget.person["cep"];
    }
  }

  @override
  void dispose() {
    _cpfController.removeListener(_validateCPF);
    _cpfController.dispose();
    super.dispose();
  }

  void _validateCPF() {
    setState(() {
      _cpfError = _cpfController.text.isNotEmpty &&
              !CPFValidator.isValid(_cpfController.text)
          ? PersonConstants.cpfErrorMessage
          : null;
    });
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
                  checkRequiredFields(_nameController);
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
                    checkRequiredFields(_cpfController);
                  },
                  isRequired: true),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.birthDateLabel),
              CustomTextField(
                  maskedController: _birthDateController,
                  keyboardType: TextInputType.datetime,
                  hintText: PersonConstants.birthDateHint,
                  onChange: (value) {
                    checkRequiredFields(_birthDateController);
                  },
                  isRequired: true),
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
                    checkRequiredFields(_cellPhoneController);
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
                          saveData();
                          Navigator.of(context).pop();
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

  void saveData() {
    NaturalPerson person = NaturalPerson();
    if (widget.person["id"] != null) {
      person.id = widget.person["id"];
    }
    person.name = _nameController.text;
    person.cpf = _cpfController.text;
    person.email = _emailController.text;
    person.civilState = _selectedCivilStatus;
    person.career = _careerController.text;
    person.sex = _sexController;
    person.cellPhone = _cellPhoneController.text;
    person.birthDate = _birthDateController.text;
    person.cep = _cepController.text;
    person.street = _streetController.text;
    person.state = _stateController.text;
    person.city = _cityController.text;
    person.neighborhood = _neighborhoodController.text;
    if (_addressNumberController.text.isNotEmpty) {
      person.addressNumber = int.parse(_addressNumberController.text);
    }
    person.addressComplement = _addressComplementController.text;

    DaoService daoService = DaoService(collectionName: "pessoa_fisica");

    daoService.save(person).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(GeneralConstants.dataSaved)),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados: $error')),
      );
    });
  }

  Future<void> _fetchAddress(String cep) async {
    final data = await FetchAddressService().fetchAddress(cep);
    if (data != null) {
      setState(() {
        _streetController.text = data['logradouro'];
        _neighborhoodController.text = data['bairro'];
        _stateController.text = data['uf'];
        _cityController.text = data['localidade'];
        _isAddressEditable = true;
      });
    }
  }

  void checkRequiredFields(TextEditingController textControllers) {
    bool isAllFieldsFilled = true;

    if (textControllers.text.isEmpty) {
      isAllFieldsFilled = false;
    }

    setState(() {
      _isSaveButtonEnabled = isAllFieldsFilled;
    });
  }
}