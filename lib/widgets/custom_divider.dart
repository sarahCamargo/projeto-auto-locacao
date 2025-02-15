import 'package:flutter/material.dart';

import '../constants/colors_constants.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: ColorsConstants.dividerColor,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }
}
