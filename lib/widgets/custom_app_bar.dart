import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasReturnScreen;

  const CustomAppBar(
      {super.key, required this.title, this.hasReturnScreen = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFFE8E8E8),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF737373)),
      ),
      leading: hasReturnScreen
          ? IconButton(
              icon: const Icon(FontAwesomeIcons.angleLeft,
                  color: Color(0xFF737373)),
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
