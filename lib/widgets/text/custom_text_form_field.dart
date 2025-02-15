import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

typedef OnChangeCallback = void Function(String value);
typedef OnTapCallback = void Function();

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final MaskedTextController? maskedController;
  final TextInputType keyboardType;
  final String? hintText;
  final String? errorText;
  final bool readOnly;
  final OnChangeCallback? onChange;
  final bool isRequired;
  final String? labelText;
  final bool isCapitalized;
  final OnTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField(
      {super.key,
      this.controller,
      this.maskedController,
      this.keyboardType = TextInputType.text,
      this.hintText,
      this.errorText,
      this.readOnly = false,
      this.onChange,
      this.isRequired = false,
      this.labelText,
      this.isCapitalized = false,
      this.onTap,
      this.inputFormatters});

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late Color _borderColor;

  @override
  void initState() {
    super.initState();
    _updateBorderColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
          controller: widget.controller ?? widget.maskedController,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          onChanged: (value) {
            widget.onChange?.call(value);
            _updateBorderColor();
          },
          textCapitalization: widget.isCapitalized
              ? TextCapitalization.characters
              : TextCapitalization.none,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color(0xFFA6A6A6)),
            errorText: widget.errorText,
          ),
          onTap: () {
            widget.onTap?.call();
          },
          inputFormatters: widget.inputFormatters),
    );
  }

  void _updateBorderColor() {
    setState(() {
      if (widget.isRequired &&
          ((widget.controller?.text.isEmpty ?? true) &&
              (widget.maskedController?.text.isEmpty ?? true))) {
        _borderColor = Colors.red;
      } else {
        _borderColor = Colors.grey;
      }
    });
  }
}
