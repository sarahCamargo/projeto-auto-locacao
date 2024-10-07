import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../../constants/legal_person_constants.dart';
import '../../../constants/person_management_constants.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custom_text_label.dart';

class LegalPersonFilters extends StatefulWidget {
  final Function addFilter;
  final Map<String, dynamic> filters;

  const LegalPersonFilters({super.key, required this.addFilter, required this.filters});

  @override
  LegalPersonFiltersState createState() => LegalPersonFiltersState();
}

class LegalPersonFiltersState extends State<LegalPersonFilters> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _tradingNameController = TextEditingController();
  final MaskedTextController _cnpjController = MaskedTextController(mask: LegalPersonConstants.cnpjMask);
  final TextEditingController _legalResponsibleController = TextEditingController();
  final MaskedTextController _legalResponsibleCPFController = MaskedTextController(mask: PersonConstants.cpfMask);

  @override
  void initState() {
    super.initState();
    if (widget.filters['companyName'] != null && widget.filters['companyName'].toString().isNotEmpty) {
      _companyNameController.text = widget.filters['companyName'];
    }
    if (widget.filters['tradingName'] != null && widget.filters['tradingName'].toString().isNotEmpty) {
      _tradingNameController.text = widget.filters['tradingName'];
    }
    if (widget.filters['cnpj'] != null && widget.filters['cnpj'].toString().isNotEmpty) {
      _cnpjController.text = widget.filters['cnpj'];
    }
    if (widget.filters['legalResponsible'] != null && widget.filters['legalResponsible'].toString().isNotEmpty) {
      _legalResponsibleController.text = widget.filters['legalResponsible'];
    }
    if (widget.filters['legalResponsibleCpf'] != null && widget.filters['legalResponsibleCpf'].toString().isNotEmpty) {
      _legalResponsibleCPFController.text = widget.filters['legalResponsibleCpf'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTextLabel(
            label: LegalPersonConstants.companyName,
          ),
          CustomTextField(
            controller: _companyNameController,
            onChange: (texto) {
              widget.addFilter('companyName', texto.toString());
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomTextLabel(
            label: LegalPersonConstants.tradingName,
          ),
          CustomTextField(
            controller: _tradingNameController,
            onChange: (texto) {
              widget.addFilter('tradingName', texto.toString());
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomTextLabel(
            label: LegalPersonConstants.cnpjLabel,
          ),
          CustomTextField(
            maskedController: _cnpjController,
            hintText: LegalPersonConstants.cnpjMask,
            keyboardType: TextInputType.number,
            onChange: (texto) {
              print(texto);
              widget.addFilter('cnpj', texto.toString());
            },
          ),
          const SizedBox(height: 16.0),
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
            onChange: (texto) {
              widget.addFilter('legalResponsible', texto.toString());
            },
          ),
          const CustomTextLabel(
              label: LegalPersonConstants.legalResposibleCPF),
          CustomTextField(
            controller: _legalResponsibleCPFController,
            hintText: PersonConstants.cpfMask,
            keyboardType: TextInputType.number,
            onChange: (texto) {
              widget.addFilter('legalResponsibleCpf', texto.toString());
            },
          ),
        ]
    );
  }
}