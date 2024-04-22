import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/person_management_constants.dart';
import 'package:projeto_auto_locacao/screens/person_management/legal_person/legal_person_management.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';

import 'natural_person/natural_person_management.dart';

class PersonManagement extends StatefulWidget {
  const PersonManagement({super.key});

  @override
  PersonManagementState createState() => PersonManagementState();
}

class PersonManagementState extends State<PersonManagement> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: PersonConstants.personManagementTitle,
          hasReturnScreen: true,
        ),
        body: const TabBarView(children: [NaturalPersonManagement(), LegalPersonManagement()]),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: const TabBar(tabs: [
            Tab(
              icon: Icon(FontAwesomeIcons.userGroup, color: ColorsConstants.iconColor,),
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.userTie, color: ColorsConstants.iconColor),
            )
          ]),
        ),
      ),
    );
  }
}
