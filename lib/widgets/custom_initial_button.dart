import 'package:flutter/material.dart';

import 'custom_text_label.dart';

class CustomInitialButton extends StatelessWidget {
  final String text;
  final Widget widget;
  final IconData icon;

  const CustomInitialButton(this.text, this.widget, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget))
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          //width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFFA6A6A6),
                  size: 50,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextLabel(label: text, fontWeight: FontWeight.bold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
