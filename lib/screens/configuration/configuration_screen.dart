import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/colors_constants.dart';
import 'package:projeto_auto_locacao/constants/configuration_constants.dart';
import 'package:projeto_auto_locacao/screens/configuration/notification_conf.dart';
import 'package:projeto_auto_locacao/screens/configuration/contract_conf.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  ConfigurationScreenState createState() => ConfigurationScreenState();
}

class ConfigurationScreenState extends State<ConfigurationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: ConfigurationConstants.title,
        hasReturnScreen: true,
      ),
      body: Container(
        decoration: const BoxDecoration(color: ColorsConstants.backgroundColor),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationConf(),
              ContractConf(),
            ],
          ),
        ),
      ),
    );
  }
}
