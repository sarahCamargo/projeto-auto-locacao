import 'package:flutter/material.dart';

import '../constants/colors_constants.dart';
import 'custom_text_label.dart';

class CustomInitialButton extends StatelessWidget {
  final String text;
  final Widget widget;
  final String asset;

  const CustomInitialButton(this.text, this.widget, this.asset, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget))
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: ColorsConstants.orangeFields,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset(asset, width: 50, height: 50),
                const SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: CustomTextLabel(
                    label: text,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
