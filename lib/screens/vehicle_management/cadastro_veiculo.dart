import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_constants.dart';
import 'package:projeto_auto_locacao/models/veiculo.dart';
import 'package:projeto_auto_locacao/services/dao_service.dart';

import '../../constants/colors_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_text_label.dart';

class CadastroVeiculo extends StatefulWidget {
  @override
  _CadastroVeiculoState createState() => _CadastroVeiculoState();

  final Map<String, dynamic> veiculo;

  const CadastroVeiculo({super.key, required this.veiculo});
}

class _CadastroVeiculoState extends State<CadastroVeiculo> {
  String? _selectedTipoCombustivel;
  String? _selectedTipoTransmissao;
  String? _selectedCondicao;
  XFile? _image;
  String? _imageUrl;
  bool _hasImage = false;

  final MaskedTextController _anoFabricacaoController =
      MaskedTextController(mask: '0000/0000');
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _renavanController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  bool _isSaveButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.veiculo["id"] != null) {
      _marcaController.text = widget.veiculo["marca"];
      _modeloController.text = widget.veiculo["modelo"];
      _placaController.text = widget.veiculo["placa"];
      _anoFabricacaoController.text =
          widget.veiculo["anoFabricacao"].toString();
      _renavanController.text = widget.veiculo["renavan"] != null
          ? widget.veiculo["renavan"].toString()
          : "";
      _corController.text = widget.veiculo["cor"];
      _selectedTipoCombustivel = widget.veiculo["tipoCombustivel"];
      _selectedTipoTransmissao = widget.veiculo["tipoTransmissao"];
      _selectedCondicao = widget.veiculo["condicao"];
      _descricaoController.text = widget.veiculo["descricao"];
    }

    _marcaController.addListener(_checkButtonStatus);
    _modeloController.addListener(_checkButtonStatus);
    _placaController.addListener(_checkButtonStatus);
    _renavanController.addListener(_checkButtonStatus);
    _anoFabricacaoController.addListener(_checkButtonStatus);
    _corController.addListener(_checkButtonStatus);
    _checkButtonStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: VehicleConstants.appBarTitle),
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
                label: VehicleConstants.vehicleData,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              const SizedBox(height: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: _getImageFromGallery,
                      child: _buildImageAndButton()),
                  const SizedBox(height: 20),
                  _imageUrl != null ? Image.network(_imageUrl!) : Container(),
                ],
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
                          label: VehicleConstants.brandLabel,
                        ),
                        CustomTextField(
                          controller: _marcaController,
                          keyboardType: TextInputType.name,
                          onChange: (value) {
                            _updateSaveButtonState(_marcaController);
                          },
                          isRequired: true,
                        )
                      ],
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextLabel(
                          label: VehicleConstants.modelLabel,
                        ),
                        CustomTextField(
                          controller: _modeloController,
                          keyboardType: TextInputType.name,
                          onChange: (value) {
                            _updateSaveButtonState(_modeloController);
                          },
                          isRequired: true,
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
                          label: VehicleConstants.licensePlateLabel,
                        ),
                        CustomTextField(
                          controller: _placaController,
                          keyboardType: TextInputType.name,
                          onChange: (value) {
                            _updateSaveButtonState(_placaController);
                          },
                          isRequired: true,
                          isCapitalized: true,
                        )
                      ],
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextLabel(
                          label: VehicleConstants.renavamLabel,
                        ),
                        CustomTextField(
                          controller: _renavanController,
                          keyboardType: TextInputType.number,
                          onChange: (value) {
                            _updateSaveButtonState(_renavanController);
                          },
                          isRequired: true,
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
                          label: VehicleConstants.yearLabel,
                        ),
                        CustomTextField(
                          controller: _anoFabricacaoController,
                          keyboardType: TextInputType.number,
                          onChange: (value) {
                            _updateSaveButtonState(_anoFabricacaoController);
                          },
                          isRequired: true,
                        )
                      ],
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTextLabel(
                          label: VehicleConstants.colorLabel,
                        ),
                        CustomTextField(
                          controller: _corController,
                          keyboardType: TextInputType.name,
                          onChange: (value) {
                            _updateSaveButtonState(_corController);
                          },
                          isRequired: true,
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
                          label: VehicleConstants.typeOfFuelLabel,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButtonFormField<String>(
                            value: _selectedTipoCombustivel,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: VehicleConstants.typeOfFuel.map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: status == null
                                    ? const Text(GeneralConstants.doNotInform)
                                    : Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTipoCombustivel = value;
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
                          label: VehicleConstants.transmissionLabel,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButtonFormField<String>(
                            value: _selectedTipoTransmissao,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: VehicleConstants.transmission.map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: status == null
                                    ? const Text(GeneralConstants.doNotInform)
                                    : Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTipoTransmissao = value;
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
                          label: VehicleConstants.conditionLabel,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCondicao,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: VehicleConstants.condition.map((status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: status == null
                                    ? const Text(GeneralConstants.doNotInform)
                                    : Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCondicao = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              const CustomTextLabel(
                label: VehicleConstants.descriptionLabel,
              ),
              CustomTextField(
                controller: _descricaoController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: _isSaveButtonEnabled
                      ? () {
                          salvarDados();
                          Navigator.of(context).pop();
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

  void salvarDados() {
    Veiculo veiculo = new Veiculo();
    if (widget.veiculo["id"] != null) {
      veiculo.id = widget.veiculo["id"];
    }
    veiculo.placa = _placaController.text;
    veiculo.modelo = _modeloController.text;
    veiculo.marca = _marcaController.text;
    veiculo.anoFabricacao = _anoFabricacaoController.text;
    if (_renavanController.text.isNotEmpty) {
      veiculo.renavan = int.parse(_renavanController.text);
    }
    veiculo.cor = _corController.text;
    veiculo.descricao = _descricaoController.text;

    DaoService daoService = DaoService(collectionName: "veiculos");

    daoService.save(veiculo).then((value) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: "sarahcamargo00@gmail.com",
        password: "721*klmno_AB430",
      )
          .then((value) {
        _uploadImageToFirebase().then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dados salvos com sucesso'),
              duration: Duration(seconds: 3),
            ),
          );
        });
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar dados: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void _checkButtonStatus() {
    setState(() {
      _isSaveButtonEnabled = _marcaController.text.isNotEmpty &&
          _modeloController.text.isNotEmpty &&
          _placaController.text.isNotEmpty &&
          _renavanController.text.isNotEmpty &&
          _anoFabricacaoController.text.isNotEmpty &&
          _corController.text.isNotEmpty;
    });
  }

  void _updateSaveButtonState(TextEditingController textEditingController) {
    setState(() {
      _isSaveButtonEnabled = textEditingController.text.isNotEmpty;
    });
  }

  Future<void> _getImageFromGallery() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _hasImage = true;
      });
    }
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      if (_image != null) {
        final File file = File(_image!.path);
        final fileName = 'images/${DateTime.now()}.png';

        final ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(file);
        _imageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('veiculos')
            .add({'image': _imageUrl});
      }
    } catch (e) {
      rethrow;
    }
  }

  Widget _buildImageContainer() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: _image == null
          ? Center(
              child: Icon(
                FontAwesomeIcons.squarePlus,
                size: 50,
                color: Colors.grey[400],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(_image!.path),
                fit: BoxFit.contain,
              ),
            ),
    );
  }

  Widget _buildRemoveImageButton() {
    return Positioned(
      right: 0,
      top: 0,
      child: IconButton(
        icon: const Icon(
          FontAwesomeIcons.xmark,
          color: ColorsConstants.iconColor,
        ),
        onPressed: _removeImage,
      ),
    );
  }

  Widget _buildImageAndButton() {
    return Stack(
      children: [
        _buildImageContainer(),
        if (_hasImage) _buildRemoveImageButton(),
      ],
    );
  }

  void _removeImage() {
    setState(() {
      _image = null;
      _hasImage = false;
    });
  }

  void signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "",
        password: "",
      );
    } catch (e) {
      print("Erro ao autenticar usuário: $e");
    }
  }
}
