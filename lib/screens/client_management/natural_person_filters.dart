import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../constants/client_constants.dart';
import '../../widgets/text/custom_text_form_field.dart';
import '../../widgets/text/custom_text_label.dart';

class NaturalPersonFilters extends StatefulWidget {
  final Function addFilter;
  final Map<String, dynamic> filters;

  const NaturalPersonFilters({super.key, required this.addFilter, required this.filters});

  @override
  NaturalPersonFiltersState createState() => NaturalPersonFiltersState();
}

class NaturalPersonFiltersState extends State<NaturalPersonFilters> {
  final TextEditingController _nameController = TextEditingController();
  final MaskedTextController _cpfController = MaskedTextController(mask: ClientConstants.cpfMask);

  @override
  void initState() {
    super.initState();
    if (widget.filters['name'] != null && widget.filters['name'].toString().isNotEmpty) {
      _nameController.text = widget.filters['name'];
    }
    if (widget.filters['cpf'] != null && widget.filters['cpf'].toString().isNotEmpty) {
      _cpfController.text = widget.filters['cpf'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTextLabel(
            label: ClientConstants.nameLabel,
          ),
          CustomTextField(
            controller: _nameController,
            onChange: (texto) {
              widget.addFilter('name', texto.toString());
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomTextLabel(
            label: ClientConstants.cpfLabel,
          ),
          CustomTextField(
            maskedController: _cpfController,
            keyboardType: TextInputType.number,
            hintText: ClientConstants.cpfMask,
            onChange: (texto) {
              widget.addFilter('cpf', texto.toString());
            },
          ),
        ]
    );
  }
}