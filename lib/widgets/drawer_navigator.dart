import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/home_page_constants.dart';
import 'package:projeto_auto_locacao/screens/configuration/configuration_screen.dart';
import 'package:projeto_auto_locacao/widgets/text/custom_text_label.dart';

class DrawerNavigator extends StatelessWidget implements PreferredSizeWidget {
  const DrawerNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsConstants.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 125,
            child: DrawerHeader(
              decoration: BoxDecoration(color: ColorsConstants.blueFields),
              child: CustomTextLabel(
                label: HomePageConstants.menu,
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.house,
                color: ColorsConstants.iconColor),
            title: const CustomTextLabel(
              label: HomePageConstants.homeTitle,
              fontWeight: FontWeight.bold,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.gear,
                color: ColorsConstants.iconColor),
            title: const CustomTextLabel(
              label: HomePageConstants.settings,
              fontWeight: FontWeight.bold,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfigurationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
