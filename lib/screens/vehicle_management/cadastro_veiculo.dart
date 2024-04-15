import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/models/veiculo.dart';
import 'package:projeto_auto_locacao/services/veiculo_service.dart';

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
      appBar: AppBar(
        title: Text('Cadastrar Veículo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                  label: "Dados do veículo",
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
                              const CustomTextLabel(label: "Marca",),
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
                              const CustomTextLabel(label: "Modelo",),
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
                              const CustomTextLabel(label: "Placa",),
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
                              const CustomTextLabel(label: "Renavan",),
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
                              const CustomTextLabel(label: "Ano",),
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
                              const CustomTextLabel(label: "Cor",),
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
                              const CustomTextLabel(label: "Quilometragem",),
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
                              const CustomTextLabel(label: "Tipo combustível",),
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
                              const CustomTextLabel(label: "Nº Portas",),
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
                              const CustomTextLabel(label: "Transmissão",),
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
                              const CustomTextLabel(label: "Condição",),
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
                              const CustomTextLabel(label: "Nº Assentos",),
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
                const CustomTextLabel(label: "Descrição",),
                CustomTextField(
                  controller: _descricaoController,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isSaveButtonEnabled
                      ? () {
                    salvarDados();
                  }
                      : null,
                  child: const Text("Salvar"),
                ),
              ],
            ),
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

    VeiculoService.salvaVeiculo(veiculo).then((value) {
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



