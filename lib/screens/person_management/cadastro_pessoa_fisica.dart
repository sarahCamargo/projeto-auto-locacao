import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_auto_locacao/constants/person_management_constants.dart';
import 'package:projeto_auto_locacao/models/pessoa_fisica.dart';
import 'package:projeto_auto_locacao/screens/person_management/listar_pessoas.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_form_field.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:http/http.dart' as http;

class CadastroPessoaFisica extends StatefulWidget {

  @override
  _CadastroPessoaFisicaState createState() => _CadastroPessoaFisicaState();

  final Map<String, dynamic> pessoa;

  const CadastroPessoaFisica({super.key, required this.pessoa});
}

class _CadastroPessoaFisicaState extends State<CadastroPessoaFisica> {
  String? _cpfError;
  String? _selectedCivilStatus;
  String _sexController = '';
  bool _isAddressEditable = false;
  bool _isSaveButtonEnabled = false;

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _civilStateController = TextEditingController();
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
    if (widget.pessoa["id"] != null) {
      _nameController.text = widget.pessoa["nome"];
      _cpfController.text = widget.pessoa["cpf"].toString();
      _emailController.text = widget.pessoa["email"];
      _cepController.text = widget.pessoa["endereco"];
      _civilStateController.text = widget.pessoa["estado_civil"];
      _careerController.text = widget.pessoa["profissao"];
      _sexController = widget.pessoa["sexo"];
      _cellPhoneController.text = widget.pessoa["telefone"].toString();
      _birthDateController.text = widget.pessoa["dtNascimento"];
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const CustomTextLabel(label: PersonConstants.personalData,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
              const SizedBox(height: 18.0),
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
                  onChange: (value) {
                    checkRequiredFields(_cellPhoneController);
                  },
                  isRequired: true),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: PersonConstants.cepLabel,
                ),
                onChanged: (value) {
                  _fetchAddress(value);
                },
              ),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isSaveButtonEnabled
                    ? () {
                  saveData();
                }
                    : null,
                child: const Text(PersonConstants.saveButton),
              ),
            ],
          ),
        ));
  }

  void saveData() {
    if (widget.pessoa["id"] == null) {
      PessoaFisica pessoaFisica = PessoaFisica(
          id: const Uuid().v1(),
          nome: _nameController.text,
          cpf: _cpfController.text,
          email: _emailController.text,
          endereco: _cepController.text,
          estadoCivil: _civilStateController.text,
          profissao: _careerController.text,
          sexo: _sexController,
          telefone: _cellPhoneController.text,
          dtNascimento: _birthDateController.text);
      FirebaseFirestore.instance
          .collection('pessoa_fisica')
          .doc(pessoaFisica.id)
          .set(pessoaFisica.toMap())
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos com sucesso')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados: $error')),
        );
      });
    } else {
      FirebaseFirestore.instance
          .collection('pessoa_fisica')
          .doc(widget.pessoa["id"])
          .update({
        "nome": _nameController.text,
        "cpf": _cpfController.text,
        "email": _emailController.text,
        "endereco": _cepController.text,
        "estadoCivil": _civilStateController.text,
        "profissao": _careerController.text,
        "sexo": _sexController,
        "telefone": _cellPhoneController.text,
        "dtNascimento": _birthDateController.text
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos com sucesso')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListaPessoas()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados: $error')),
        );
      });
    }
  }

  Future<void> _fetchAddress(String cep) async {
    cep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length == 8) {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _streetController.text = data['logradouro'];
            _neighborhoodController.text = data['bairro'];
            _stateController.text = data['uf'];
            _cityController.text = data['localidade'];
            _isAddressEditable = true;
          });
        } else {
          throw Exception('Failed to fetch address');
        }
      } catch (e) {
        print('Error: $e');
      }
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
