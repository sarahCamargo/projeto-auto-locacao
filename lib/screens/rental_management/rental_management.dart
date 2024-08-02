import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/rental_constants.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental/rental_screen.dart';
import 'package:projeto_auto_locacao/screens/vehicle_management/vehicle/vehicle_screen.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';


class RentalManagement extends StatefulWidget {
  const RentalManagement({super.key});

  @override
  RentalManagementState createState() => RentalManagementState();
}

class RentalManagementState extends State<RentalManagement> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: RentalConstants.rentalManagementTitle,
          hasReturnScreen: true,
        ),
        body: const TabBarView(children: [RentalScreen(), RentalScreen(isHistory: true)]),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: const TabBar(tabs: [
            Tab(
              text: RentalConstants.rentalPrimaryTab,
              icon: Icon(FontAwesomeIcons.handHoldingDollar, color: ColorsConstants.iconColor,),
            ),
            Tab(
              text: RentalConstants.rentalHistoryTab,
              icon: Icon(FontAwesomeIcons.clockRotateLeft, color: ColorsConstants.iconColor),
            )
          ]),
        ),
      ),
    );
  }
}
