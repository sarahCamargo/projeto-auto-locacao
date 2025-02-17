import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:projeto_auto_locacao/constants/client_constants.dart';
import 'package:projeto_auto_locacao/services/fetch_address_service.dart';
import 'package:projeto_auto_locacao/utils/show_snackbar.dart';
import 'package:projeto_auto_locacao/widgets/text/custom_text_form_field.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:projeto_auto_locacao/widgets/text/register_text_label.dart';

import '../../../constants/collection_names.dart';
import '../../../constants/legal_person_constants.dart';
import '../../../models/legal_person.dart';
import '../../../services/database/database_handler.dart';
import '../../../services/validation_service.dart';
import '../../widgets/buttons/register_save_button.dart';

class LegalPersonRegister extends StatefulWidget {
  @override
  LegalPersonRegisterState createState() => LegalPersonRegisterState();
  final Map<String, dynamic> legalPerson;

  const LegalPersonRegister({super.key, required this.legalPerson});
}

class LegalPersonRegisterState extends State<LegalPersonRegister> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.legalPerson);
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
      MaskedTextController(mask: ClientConstants.cepMask);
  final MaskedTextController _cnpjController =
      MaskedTextController(mask: LegalPersonConstants.cnpjMask);
  final MaskedTextController _cellPhoneController =
      MaskedTextController(mask: ClientConstants.cellPhoneMask);
  final MaskedTextController _legalResponsibleCpfController =
      MaskedTextController(mask: ClientConstants.cpfMask);

  @override
  void initState() {
    super.initState();
    _cnpjController.addListener(_validateCNPJ);
    _legalResponsibleCpfController.addListener(_validateCPF);
    if (widget.legalPerson["id"] != null) {
      _companyNameController.text = widget.legalPerson["companyName"];
      _tradingNameController.text = widget.legalPerson["tradingName"];
      _cnpjController.text = widget.legalPerson["cnpj"];
      _stateRegistrationController.text =
          widget.legalPerson["stateRegistration"]?.toString() ?? '';
      _emailController.text = widget.legalPerson["email"]?.toString() ?? '';
      ;
      _cellPhoneController.text = widget.legalPerson["cellPhone"] ?? '';
      if (widget.legalPerson["cep"] != null) {
        _isAddressEditable = true;
        _cepController.text = widget.legalPerson["cep"];
        _stateController.text = widget.legalPerson["state"];
        _cityController.text = widget.legalPerson["city"];
        _streetController.text = widget.legalPerson["street"];
        _neighborhoodController.text = widget.legalPerson["neighborhood"];
        if (widget.legalPerson["addressNumber"] != null) {
          _addressNumberController.text =
              widget.legalPerson["addressNumber"].toString();
        }
        _addressComplementController.text =
            widget.legalPerson["addressComplement"];
      }
      _legalResponsibleController.text =
          widget.legalPerson["legalResponsible"]?.toString() ?? '';
      _legalResponsibleCpfController.text =
          widget.legalPerson["legalResponsibleCpf"]?.toString() ?? '';
      _legalResponsibleRoleController.text =
          widget.legalPerson["legalResponsibleRole"]?.toString() ?? '';
    }

    _companyNameController.addListener(_checkButtonStatus);
    _tradingNameController.addListener(_checkButtonStatus);
    _cnpjController.addListener(_checkButtonStatus);
    _cellPhoneController.addListener(_checkButtonStatus);
    _legalResponsibleController.addListener(_checkButtonStatus);
    _legalResponsibleCpfController.addListener(_checkButtonStatus);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 16.0),
        const RegisterTextLabel(
          label: LegalPersonConstants.companyData,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: LegalPersonConstants.companyName),
        CustomTextField(
          controller: _companyNameController,
          onChange: (value) {
            _updateSaveButtonState(_companyNameController);
          },
          keyboardType: TextInputType.name,
          isRequired: true,
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: LegalPersonConstants.tradingName),
        CustomTextField(
          controller: _tradingNameController,
          onChange: (value) {
            _updateSaveButtonState(_tradingNameController);
          },
          isRequired: true,
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: LegalPersonConstants.cnpjLabel),
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
        const RegisterTextLabel(
            label: LegalPersonConstants.stateRegistrationLabel),
        CustomTextField(
          controller: _stateRegistrationController,
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: ClientConstants.emailLabel),
        CustomTextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
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
        const SizedBox(height: 16.0),
        const RegisterTextLabel(
            label: LegalPersonConstants.legalResponsible,
            fontWeight: FontWeight.bold),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(
            label: LegalPersonConstants.legalResponsibleName),
        CustomTextField(
          controller: _legalResponsibleController,
          isRequired: true,
          onChange: (value) {
            _updateSaveButtonState(_legalResponsibleController);
          },
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(label: LegalPersonConstants.legalResposibleCPF),
        CustomTextField(
          controller: _legalResponsibleCpfController,
          hintText: ClientConstants.cpfMask,
          errorText: _cpfError,
          isRequired: true,
          keyboardType: TextInputType.number,
          onChange: (value) {
            _updateSaveButtonState(_legalResponsibleCpfController);
          },
        ),
        const SizedBox(height: 16.0),
        const RegisterTextLabel(
            label: LegalPersonConstants.legalResponsibleRole),
        CustomTextField(
          controller: _legalResponsibleRoleController,
        ),
        const SizedBox(height: 16.0),
        RegisterSaveButton(onPressed: pressSave(context)),
        const SizedBox(height: 16.0),
      ],
    );
  }

  pressSave(BuildContext context) {
    if (_isSaveButtonEnabled) {
      return () {
        isCNPJRegistered().then((isRegistered) {
          if (isRegistered) {
            showCustomSnackBar(
                context, LegalPersonConstants.cnpjAlreadyRegistered);
          } else {
            saveData();
          }
        });
      };
    }
    return () => {};
  }

  Future<bool> isCNPJRegistered() async {
    if (widget.legalPerson['id'] == null ||
        widget.legalPerson['cnpj'] != _cnpjController.text) {
      return await isCnpjAlreadyRegistered(_cnpjController.text);
    }
    return false;
  }

  void saveData() {
    LegalPerson legalPerson = LegalPerson();
    legalPerson.cnpj = _cnpjController.text;
    legalPerson.email = _emailController.text;
    legalPerson.tradingName = _tradingNameController.text;
    legalPerson.companyName = _companyNameController.text;
    legalPerson.stateRegistration = _stateRegistrationController.text;
    legalPerson.legalResponsible = _legalResponsibleController.text;
    legalPerson.legalResponsibleCpf = _legalResponsibleCpfController.text;
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

    dbHandler.save(context, widget.legalPerson["id"], legalPerson);
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
      if (_legalResponsibleCpfController.text.isNotEmpty &&
          !CPFValidator.isValid(_legalResponsibleCpfController.text)) {
        _cpfError = ClientConstants.cpfErrorMessage;
        _isSaveButtonEnabled = false;
      } else {
        _cpfError = null;
      }
    });
  }
}
