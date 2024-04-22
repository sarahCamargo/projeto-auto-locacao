import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/services/fetch_address_service.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_form_field.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';

import '../../../constants/legal_person_constants.dart';
import '../../../constants/person_management_constants.dart';
import '../../../models/legal_person.dart';
import '../../../services/dao_service.dart';
import '../../../services/validation_service.dart';

class LegalPersonRegister extends StatefulWidget {
  @override
  LegalPersonRegisterState createState() => LegalPersonRegisterState();
  final Map<String, dynamic> legalPerson;

  const LegalPersonRegister({super.key, required this.legalPerson});
}

class LegalPersonRegisterState extends State<LegalPersonRegister> {
  String? _cnpjError;
  String? _cpfError;
  bool _isAddressEditable = false;
  bool _isSaveButtonEnabled = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tradingNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _legalResponsibleController =
      TextEditingController();
  final TextEditingController _legalResponsibleRoleController =
      TextEditingController();
  final TextEditingController _stateRegistrationController =
      TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _addressNumberController =
      TextEditingController();
  final TextEditingController _addressComplementController =
      TextEditingController();

  final MaskedTextController _cepController =
      MaskedTextController(mask: PersonConstants.cepMask);
  final MaskedTextController _cnpjController =
      MaskedTextController(mask: LegalPersonConstants.cnpjMask);
  final MaskedTextController _cellPhoneController =
      MaskedTextController(mask: PersonConstants.cellPhoneMask);
  final MaskedTextController _legalResponsibleCPFController =
      MaskedTextController(mask: PersonConstants.cpfMask);

  @override
  void initState() {
    super.initState();
    _cnpjController.addListener(_validateCNPJ);
    _legalResponsibleCPFController.addListener(_validateCPF);
    if (widget.legalPerson["id"] != null) {
      _companyNameController.text = widget.legalPerson["company_name"];
      _tradingNameController.text = widget.legalPerson["trading_name"];
      _cnpjController.text = widget.legalPerson["cnpj"];
      _stateRegistrationController.text =
          widget.legalPerson["state_registration"];
      _emailController.text = widget.legalPerson["email"];
      _cellPhoneController.text = widget.legalPerson["cell_phone"];
      _cepController.text = widget.legalPerson["cep"];
      _stateController.text = widget.legalPerson["state"];
      _cityController.text = widget.legalPerson["city"];
      _streetController.text = widget.legalPerson["street"];
      _neighborhoodController.text = widget.legalPerson["neighborhood"];
      if (widget.legalPerson["address_number"] != null) {
        _addressNumberController.text = widget.legalPerson["address_number"];
      }
      _addressComplementController.text =
          widget.legalPerson["address_complement"];
      _legalResponsibleController.text =
          widget.legalPerson["legal_responsible"];
      _legalResponsibleCPFController.text =
          widget.legalPerson["legal_responsible_cpf"];
      _legalResponsibleRoleController.text =
          widget.legalPerson["legal_responsible_role"];
    }

    _companyNameController.addListener(_checkButtonStatus);
    _tradingNameController.addListener(_checkButtonStatus);
    _cnpjController.addListener(_checkButtonStatus);
    _cellPhoneController.addListener(_checkButtonStatus);
    _legalResponsibleController.addListener(_checkButtonStatus);
    _legalResponsibleCPFController.addListener(_checkButtonStatus);
    _checkButtonStatus();
  }

  @override
  void dispose() {
    _cnpjController.removeListener(_validateCNPJ);
    _cnpjController.dispose();
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
                label: LegalPersonConstants.companyData,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: LegalPersonConstants.companyName),
              CustomTextField(
                controller: _companyNameController,
                onChange: (value) {
                  _updateSaveButtonState(_companyNameController);
                },
                isRequired: true,
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: LegalPersonConstants.tradingName),
              CustomTextField(
                controller: _tradingNameController,
                onChange: (value) {
                  _updateSaveButtonState(_tradingNameController);
                },
                isRequired: true,
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: LegalPersonConstants.cnpjLabel),
              CustomTextField(
                  maskedController: _cnpjController,
                  keyboardType: TextInputType.number,
                  hintText: LegalPersonConstants.cnpjMask,
                  errorText: _cnpjError,
                  onChange: (value) {
                    _updateSaveButtonState(_cnpjController);
                  },
                  isRequired: true),
              const SizedBox(height: 16.0),
              const CustomTextLabel(
                  label: LegalPersonConstants.stateRegistrationLabel),
              CustomTextField(
                controller: _stateRegistrationController,
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(label: PersonConstants.emailLabel),
              CustomTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
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
              const SizedBox(height: 16.0),
              const CustomTextLabel(
                  label: LegalPersonConstants.legalResponsible,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
              const SizedBox(height: 16.0),
              const CustomTextLabel(
                  label: LegalPersonConstants.legalResponsibleName),
              CustomTextField(
                controller: _legalResponsibleController,
                isRequired: true,
                onChange: (value) {
                  _updateSaveButtonState(_legalResponsibleController);
                },
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(
                  label: LegalPersonConstants.legalResposibleCPF),
              CustomTextField(
                controller: _legalResponsibleCPFController,
                hintText: PersonConstants.cpfMask,
                errorText: _cpfError,
                isRequired: true,
                onChange: (value) {
                  _updateSaveButtonState(_legalResponsibleCPFController);
                },
              ),
              const SizedBox(height: 16.0),
              const CustomTextLabel(
                  label: LegalPersonConstants.legalResponsibleRole),
              CustomTextField(
                controller: _legalResponsibleRoleController,
              ),
              ElevatedButton(
                  onPressed: _isSaveButtonEnabled
                      ? () {
                          isCNPJRegistered().then((isRegistered) {
                            if (isRegistered) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'CNPJ já cadastrado. Não é possível salvar.'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              saveData();
                              Navigator.of(context).pop();
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

  Future<bool> isCNPJRegistered() async {
    if (widget.legalPerson['id'] == null || widget.legalPerson['cnpj'] != _cnpjController.text) {
      return await isCnpjAlreadyRegistered(_cnpjController.text);
    }
    return false;
  }

  void saveData() {
    LegalPerson legalPerson = LegalPerson();
    if (widget.legalPerson["id"] != null) {
      legalPerson.id = widget.legalPerson["id"];
    }
    legalPerson.cnpj = _cnpjController.text;
    legalPerson.email = _emailController.text;
    legalPerson.tradingName = _tradingNameController.text;
    legalPerson.companyName = _companyNameController.text;
    legalPerson.stateRegistration = _stateRegistrationController.text;
    legalPerson.legalResponsible = _legalResponsibleController.text;
    legalPerson.legalResponsibleCPF = _legalResponsibleCPFController.text;
    legalPerson.legalResponsibleRole = _legalResponsibleRoleController.text;
    legalPerson.cellPhone = _cellPhoneController.text;
    legalPerson.cep = _cepController.text;
    legalPerson.street = _streetController.text;
    legalPerson.state = _stateController.text;
    legalPerson.city = _cityController.text;
    legalPerson.neighborhood = _neighborhoodController.text;
    if (_addressNumberController.text.isNotEmpty) {
      legalPerson.addressNumber = int.parse(_addressNumberController.text);
    }
    legalPerson.addressComplement = _addressComplementController.text;

    DaoService daoService = DaoService(collectionName: "pessoa_juridica");

    daoService.save(legalPerson).then((value) {
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
      if (data['erro'] != null) {
        setState(() {
          _streetController.text = '';
          _neighborhoodController.text = '';
          _stateController.text = '';
          _cityController.text = '';
          _isAddressEditable = false;
        });
      } else {
        setState(() {
          _streetController.text = data['logradouro'];
          _neighborhoodController.text = data['bairro'];
          _stateController.text = data['uf'];
          _cityController.text = data['localidade'];
          _isAddressEditable = true;
        });
      }
    }
  }

  void checkRequiredFields(TextEditingController? textControllers) {
    bool isAllFieldsFilled = true;

    if (textControllers!.text.isEmpty) {
      isAllFieldsFilled = false;
    }

    setState(() {
      _isSaveButtonEnabled = isAllFieldsFilled;
    });
  }

  void _checkButtonStatus() {
    setState(() {
      _isSaveButtonEnabled = _cnpjController.text.isNotEmpty &&
          _cellPhoneController.text.isNotEmpty &&
          _cnpjError == null &&
          _cpfError == null;
    });
  }

  void _updateSaveButtonState(TextEditingController textEditingController) {
    setState(() {
      _isSaveButtonEnabled = textEditingController.text.isNotEmpty &&
          _cnpjError == null &&
          _cpfError == null;
    });
  }

  void _validateCNPJ() {
    setState(() {
      if (_cnpjController.text.isNotEmpty &&
          !CNPJValidator.isValid(_cnpjController.text)) {
        _cnpjError = LegalPersonConstants.cnpjErrorMessage;
        _isSaveButtonEnabled = false;
      } else {
        _cnpjError = null;
      }
    });
  }

  void _validateCPF() {
    setState(() {
      if (_legalResponsibleCPFController.text.isNotEmpty &&
          !CPFValidator.isValid(_legalResponsibleCPFController.text)) {
        _cpfError = PersonConstants.cpfErrorMessage;
        _isSaveButtonEnabled = false;
      } else {
        _cpfError = null;
      }
    });
  }
}
