import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/home_page_constants.dart';
import 'package:projeto_auto_locacao/screens/configuration_management/configuration_screen.dart';
import 'package:projeto_auto_locacao/widgets/custom_text_label.dart';

class DrawerNavigator extends StatelessWidget implements PreferredSizeWidget {
  const DrawerNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 125,
            child: DrawerHeader(
              child: CustomTextLabel(
                label: HomePageConstants.menu,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.house,
                color: ColorsConstants.iconColor),
            title: const CustomTextLabel(
              label: HomePageConstants.homePage,
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
