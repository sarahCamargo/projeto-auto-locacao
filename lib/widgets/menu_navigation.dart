import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';

class MenuNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MenuNavigation(
      {super.key, required this.title});

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
            color: ColorsConstants.screenTitleColor),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(FontAwesomeIcons.bars, color: ColorsConstants.iconColor,),
            onPressed: () {
              Scaffold.of(context)
                  .openDrawer();
            },
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
