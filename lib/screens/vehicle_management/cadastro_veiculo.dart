import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/general_constants.dart';
import 'package:projeto_auto_locacao/constants/vehicle_management_coonstants.dart';
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

  CadastroVeiculo({required this.veiculo});
}

class _CadastroVeiculoState extends State<CadastroVeiculo> {
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _renavanController = TextEditingController();
  final TextEditingController _anoFabricacaoController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  final TextEditingController _quilometragemController = TextEditingController();
  final TextEditingController _tipoCombustivelController = TextEditingController();
  final TextEditingController _numeroPortasController = TextEditingController();
  final TextEditingController _tipoTransmissaoController = TextEditingController();
  final TextEditingController _condicaoController = TextEditingController();
  final TextEditingController _numeroAssentosController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  bool _isSaveButtonEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   if (widget.veiculo["id"] != null) {
     _marcaController.text = widget.veiculo["marca"];
     _modeloController.text = widget.veiculo["modelo"];
     _placaController.text = widget.veiculo["placa"];
     _anoFabricacaoController.text = widget.veiculo["anoFabricacao"].toString();
     _renavanController.text = widget.veiculo["renavan"].toString();
     _corController.text = widget.veiculo["cor"];
     _quilometragemController.text = widget.veiculo["quilometragem"].toString();
     _tipoCombustivelController.text = widget.veiculo["tipoCombustivel"];
     _numeroPortasController.text = widget.veiculo["numeroPortas"].toString();
     _tipoTransmissaoController.text = widget.veiculo["tipoTransmissao"];
     _condicaoController.text = widget.veiculo["condicao"];
     _numeroAssentosController.text = widget.veiculo["numeroAssentos"].toString();
     _descricaoController.text = widget.veiculo["descricao"];
   }
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
              ElevatedButton(
                  onPressed: () => {

                  },
                  child: Text("Enviar imagem")
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextLabel(label: VehicleConstants.brandLabel,),
                            CustomTextField(
                                controller: _marcaController,
                                keyboardType: TextInputType.name
                            )
                          ],
                        )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextLabel(label: VehicleConstants.modelLabel,),
                            CustomTextField(
                              controller: _modeloController,
                              keyboardType: TextInputType.name,
                              onChange: (value) {
                                checkRequiredFields(_modeloController);
                              },
                            ),
                          ],
                        )
                    )
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
                            const CustomTextLabel(label: VehicleConstants.licensePlateLabel,),
                            CustomTextField(
                                controller: _placaController,
                                keyboardType: TextInputType.name
                            )
                          ],
                        )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextLabel(label: VehicleConstants.renavamLabel,),
                            CustomTextField(
                              controller: _renavanController,
                              keyboardType: TextInputType.number,
                              onChange: (value) {
                                checkRequiredFields(_renavanController);
                              },
                            ),
                          ],
                        )
                    )
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
                            const CustomTextLabel(label: VehicleConstants.yearLabel,),
                            CustomTextField(
                                controller: _anoFabricacaoController,
                                keyboardType: TextInputType.number
                            )
                          ],
                        )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextLabel(label: VehicleConstants.colorLabel,),
                            CustomTextField(
                              controller: _corController,
                              keyboardType: TextInputType.name,
                            ),
                          ],
                        )
                    )
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
                            const CustomTextLabel(label: VehicleConstants.mileageLabel,),
                            CustomTextField(
                                controller: _quilometragemController,
                                keyboardType: TextInputType.number
                            )
                          ],
                        )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextLabel(label: VehicleConstants.typeOfFuelLabel,),
                            CustomTextField(
                              controller: _tipoCombustivelController,
                              keyboardType: TextInputType.name,
                            ),
                          ],
                        )
                    )
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
                            const CustomTextLabel(label: VehicleConstants.numberOfDoorsLabel,),
                            CustomTextField(
                                controller: _numeroPortasController,
                                keyboardType: TextInputType.number
                            )
                          ],
                        )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextLabel(label: VehicleConstants.transmissionLabel,),
                            CustomTextField(
                              controller: _tipoTransmissaoController,
                              keyboardType: TextInputType.name,
                            ),
                          ],
                        )
                    )
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
                            const CustomTextLabel(label: VehicleConstants.conditionLabel,),
                            CustomTextField(
                                controller: _condicaoController,
                                keyboardType: TextInputType.name
                            )
                          ],
                        )
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextLabel(label: VehicleConstants.numberOfSeatsLabel,),
                            CustomTextField(
                              controller: _numeroAssentosController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
              const CustomTextLabel(label: VehicleConstants.descriptionLabel,),
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
    veiculo.anoFabricacao = int.parse(_anoFabricacaoController.text);
    if (_renavanController.text.isNotEmpty) {
      veiculo.renavan = int.parse(_renavanController.text);
    }
    veiculo.cor = _corController.text;
    if (_quilometragemController.text.isNotEmpty) {
      veiculo.quilometragem = int.parse(_quilometragemController.text);
    }
    veiculo.tipoCombustivel = _tipoCombustivelController.text;
    if (_numeroPortasController.text.isNotEmpty) {
      veiculo.numeroPortas = int.parse(_numeroPortasController.text);
    }
    veiculo.tipoTransmissao = _tipoTransmissaoController.text;
    veiculo.condicao = _condicaoController.text;
    if (_numeroAssentosController.text.isNotEmpty) {
      veiculo.numeroAssentos = int.parse(_numeroAssentosController.text);
    }
    veiculo.descricao = _descricaoController.text;

    DaoService daoService = DaoService(collectionName: "veiculos");

    daoService.save(veiculo).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados salvos com sucesso')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados: $error')),
      );
    });
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



