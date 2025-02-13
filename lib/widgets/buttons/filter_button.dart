import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  FilterButtonState createState() => FilterButtonState();
}

class FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isSelected ? const Color(0xFF363636) : Colors.white,
          foregroundColor: widget.isSelected ? Colors.white : const Color(0xFF363636),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: widget.onPressed,
        child: Text(widget.label),
      ),
    );
  }
}
