import 'package:flutter/material.dart';
import 'package:projeto_auto_locacao/constants/configuration_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationConf extends StatefulWidget {
  const NotificationConf({super.key});

  @override
  NotificationConfState createState() => NotificationConfState();
}

class NotificationConfState extends State<NotificationConf> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedOption =
          prefs.getString('selected_notification_option') ?? "no_notification";
    });
  }

  Future<void> _saveSelectedOption(String? option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_notification_option', option ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  const Text(ConfigurationConstants.notifications, style: TextStyle(fontWeight: FontWeight.bold),),
                  RadioListTile<String>(
                    title: const Text(ConfigurationConstants.noNotification),
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
                    title: const Text(ConfigurationConstants.oneDayBefore),
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
                    title: const Text(ConfigurationConstants.oneWeekBefore),
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
    );
  }
}
