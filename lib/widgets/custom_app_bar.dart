import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/app_icons.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasReturnScreen;

  const CustomAppBar(
      {super.key, required this.title, this.hasReturnScreen = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: ColorsConstants.backgroundColor,
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: ColorsConstants.blueFields),
      ),
      leading: hasReturnScreen
          ? IconButton(
              icon: Image.asset(AppIcons.arrowLeft,
                  color: ColorsConstants.blueFields, width: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
