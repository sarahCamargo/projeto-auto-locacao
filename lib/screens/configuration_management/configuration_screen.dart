import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_auto_locacao/screens/configuration_management/contract_conf.dart';
import 'package:projeto_auto_locacao/widgets/custom_app_bar.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  ConfigurationScreenState createState() => ConfigurationScreenState();
}

class ConfigurationScreenState extends State<ConfigurationScreen> {
  String? _selectedOption;
  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedOption = prefs.getString('selected_notification_option') ?? "no_notification";
    });
  }

  Future<void> _saveSelectedOption(String? option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_notification_option', option ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Configurações",
        hasReturnScreen: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Notificações"),
                          RadioListTile<String>(
                            title: Text("Não notificar"),
                            value: "no_notification",
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                                _saveSelectedOption(_selectedOption);
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: Text("1 dia antes"),
                            value: "1_day_before",
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                                _saveSelectedOption(_selectedOption);
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: Text("1 semana antes"),
                            value: "1_week_before",
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                                _saveSelectedOption(_selectedOption);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const ContractConf(),
          ],
        ),
      ),
    );
  }
}
