import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/screens/person_management/client_list_screen.dart';
import 'package:projeto_auto_locacao/screens/rental_management/rental_list_screen.dart';
import 'package:projeto_auto_locacao/widgets/drawer_navigator.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/home_page_constants.dart';
import '../../../widgets/tab_bar_title.dart';
import '../../vehicle_management/maintenance/maintenance_list_screen.dart';
import '../../vehicle_management/vehicle/vehicle_list_screen.dart';
import '../quick_actions/quick_actions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        drawer: const DrawerNavigator(),
        appBar: AppBar(
          centerTitle: true,
          title: const TabBarTitle(),
        ),
        body: const TabBarView(
          children: [
            QuickActions(),
            ClientListScreen(),
            RentalListScreen(),
            VehicleListScreen(),
            MaintenanceListScreen(),
          ],
        ),
        bottomNavigationBar: Builder(
          builder: (context) {
            final TabController tabController =
                DefaultTabController.of(context);
            return Container(
              color: ColorsConstants.blueFields,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                controller: tabController,
                onTap: (index) {
                  setState(() {});
                },
                tabs: List.generate(
                  5,
                  (index) => _buildTab(index, tabController.index),
                ),
                labelStyle: const TextStyle(fontSize: 12),
                indicatorColor: ColorsConstants.orangeFields,
                unselectedLabelColor: Colors.white,
                labelColor: ColorsConstants.orangeFields,
                dividerColor: Colors.transparent,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab(int index, int selectedIndex) {
    final List<String> icons = [
      AppIcons.home,
      AppIcons.client,
      AppIcons.rental,
      AppIcons.vehicles,
      AppIcons.maintenance
    ];
    final List<String> labels = [
      HomePageConstants.homeTab,
      HomePageConstants.clientTab,
      HomePageConstants.rentalTab,
      HomePageConstants.vehicleTab,
      HomePageConstants.maintenanceTab
    ];
    return Tab(
      icon: Image.asset(
        icons[index],
        width: 32,
        height: 32,
        color: getIconColor(selectedIndex, index),
      ),
      text: labels[index],
    );
  }

  Color getIconColor(int tabSelected, int tabIndex) {
    return tabSelected == tabIndex
        ? ColorsConstants.orangeFields
        : Colors.white;
  }
}
