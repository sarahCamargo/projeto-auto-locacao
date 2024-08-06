import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/maintenance_management_constants.dart';
import 'package:projeto_auto_locacao/screens/configuration_management/contract_conf.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  ConfigurationScreenState createState() => ConfigurationScreenState();
}

class ConfigurationScreenState extends State<ConfigurationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(
          title: MaintenanceConstants.maintenanceManagementTitle,
          hasReturnScreen: true,
        ),
        body: ContractConf());
  }
}
