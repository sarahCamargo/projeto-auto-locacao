import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:projeto_auto_locacao/constants/vehicle_constants.dart';

import '../../../widgets/text/custom_text_form_field.dart';
import '../../../widgets/text/custom_text_label.dart';

class VehicleFilters extends StatefulWidget {
  final Function addFilter;
  final Map<String, dynamic> filters;

  const VehicleFilters({super.key, required this.addFilter, required this.filters});

  @override
  VehicleFiltersState createState() => VehicleFiltersState();
}

class VehicleFiltersState extends State<VehicleFilters> {

  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _renavanController = TextEditingController();
  final MaskedTextController _anoFabricacaoController =  MaskedTextController(mask: '0000');
  final TextEditingController _corController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.filters['brand'] != null && widget.filters['brand'].toString().isNotEmpty) {
      _marcaController.text = widget.filters['brand'];
    }
    if (widget.filters['model'] != null && widget.filters['model'].toString().isNotEmpty) {
      _modeloController.text = widget.filters['model'];
    }
    if (widget.filters['licensePlate'] != null && widget.filters['licensePlate'].toString().isNotEmpty) {
      _placaController.text = widget.filters['licensePlate'];
    }
    if (widget.filters['renavam'] != null && widget.filters['renavam'].toString().isNotEmpty) {
      _renavanController.text = widget.filters['renavam'].toString();
    }
    if (widget.filters['year'] != null && widget.filters['year'].toString().isNotEmpty) {
      _anoFabricacaoController.text = widget.filters['year'].toString();
    }
    if (widget.filters['color'] != null && widget.filters['color'].toString().isNotEmpty) {
      _corController.text = widget.filters['color'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTextLabel(
          label: VehicleConstants.brandLabel,
        ),
        CustomTextField(
          controller: _marcaController,
          onChange: (texto) {
            widget.addFilter('brand', texto.toString());
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const CustomTextLabel(
          label: VehicleConstants.modelLabel,
        ),
        CustomTextField(
          controller: _modeloController,
          onChange: (texto) {
            widget.addFilter('model', texto.toString());
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const CustomTextLabel(
          label: VehicleConstants.licensePlateLabel,
        ),
        CustomTextField(
          controller: _placaController,
          onChange: (texto) {
            widget.addFilter('licensePlate', texto.toString());
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const CustomTextLabel(
          label: VehicleConstants.renavamLabel,
        ),
        CustomTextField(
          controller: _renavanController,
          keyboardType: TextInputType.number,
          onChange: (texto) {
            widget.addFilter('renavam', texto.toString());
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const CustomTextLabel(
          label: VehicleConstants.yearLabel,
        ),
        CustomTextField(
          controller: _anoFabricacaoController,
          keyboardType: TextInputType.number,
          onChange: (texto) {
            widget.addFilter('year', texto.toString());
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const CustomTextLabel(
          label: VehicleConstants.colorLabel,
        ),
        CustomTextField(
          controller: _corController,
          onChange: (texto) {
            widget.addFilter('color', texto.toString());
          },
        ),
      ],
    );
  }
}