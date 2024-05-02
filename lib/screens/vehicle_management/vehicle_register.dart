import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_auto_locacao/constants/collection_names.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_constants.dart';
import 'package:projeto_auto_locacao/models/vehicle.dart';

import '../../constants/colors_constants.dart';
import '../../services/database/database_handler.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_text_label.dart';

class VehicleRegister extends StatefulWidget {
  @override
  VehicleRegisterState createState() => VehicleRegisterState();

  final Map<String, dynamic> vehicle;

  const VehicleRegister({super.key, required this.vehicle});
}

class VehicleRegisterState extends State<VehicleRegister> {
  DatabaseHandler dbHandler = DatabaseHandler(CollectionNames.vehicle);
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
    if (widget.vehicle["id"] != null) {
      _marcaController.text = widget.vehicle["brand"];
      _modeloController.text = widget.vehicle["model"];
      _placaController.text = widget.vehicle["licensePlate"];
      _anoFabricacaoController.text = widget.vehicle["year"].toString();
      _renavanController.text = widget.vehicle["renavam"] != null
          ? widget.vehicle["renavam"].toString()
          : "";
      _corController.text = widget.vehicle["color"];
      _selectedTipoCombustivel = widget.vehicle["fuelType"];
      _selectedTipoTransmissao = widget.vehicle["transmissionType"];
      _selectedCondicao = widget.vehicle["condition"];
      _descricaoController.text = widget.vehicle["description"];
      if (widget.vehicle["imageUrl"] != null) {
        _imageUrl = widget.vehicle["imageUrl"];
        _hasImage = true;
      }
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

  void save() {
    saveData().then((vehicle) {
      dbHandler.save(context, widget.vehicle['id'], vehicle);
    });
  }

  Future<Vehicle> saveData() async {
    Vehicle vehicle = Vehicle();
    vehicle.licensePlate = _placaController.text;
    vehicle.model = _modeloController.text;
    vehicle.brand = _marcaController.text;
    vehicle.year = _anoFabricacaoController.text;
    if (_renavanController.text.isNotEmpty) {
      vehicle.renavam = int.parse(_renavanController.text);
    }
    vehicle.color = _corController.text;
    vehicle.description = _descricaoController.text;
    vehicle.fuelType = _selectedTipoCombustivel;
    vehicle.transmissionType = _selectedTipoTransmissao;
    vehicle.condition = _selectedCondicao;
    vehicle.imageUrl = await _getImagePath();
    return vehicle;
  }

  String? fuelType;
  String? transmissionType;
  String? condition;

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

  Future<String?> _getImagePath() async {
    try {
      if (_image != null) {
        final File file = File(_image!.path);
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/vechile_${DateTime.now()}.png';
        await file.copy(imagePath);
        return imagePath;
      }
      if (_imageUrl != null) {
        return _imageUrl;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Widget _buildImageContainer() {
    String? newImage = _image == null ? _imageUrl : _image!.path;
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: newImage == null
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
                File(newImage),
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
      _imageUrl = null;
      _hasImage = false;
    });
  }
}
