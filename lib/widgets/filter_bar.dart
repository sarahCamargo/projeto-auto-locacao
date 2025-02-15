import 'package:flutter/cupertino.dart';

import 'buttons/filter_button.dart';

class FilterBar extends StatefulWidget {

  final List<String> filters;

  final Function(String) onFilterSelected;

  const FilterBar({super.key, required this.filters, required this.onFilterSelected});

  @override
  FilterBarState createState() => FilterBarState();
}

class FilterBarState extends State<FilterBar> {
  String selectedLabel = "Todos";

  void _onFilterSelected(String label) {
    setState(() {
      selectedLabel = label;
    });
    widget.onFilterSelected(label); // Notifica a tela principal
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.filters.map((label) {
        return FilterButton(
          label: label,
          isSelected: selectedLabel == label,
          onPressed: () => _onFilterSelected(label),
        );
      }).toList(),
    );
  }
}
