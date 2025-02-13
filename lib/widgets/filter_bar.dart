import 'package:flutter/cupertino.dart';

import 'buttons/filter_button.dart';

class FilterBar extends StatefulWidget {

  final List<String> filters;

  const FilterBar({super.key, required this.filters});

  @override
  FilterBarState createState() => FilterBarState();
}

class FilterBarState extends State<FilterBar> {
  String selectedLabel = "Todos";

  void _onFilterSelected(String label) {
    setState(() {
      selectedLabel = label;
    });
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
