import 'package:flutter/material.dart';

class CustomInitialButton extends StatelessWidget {
  final String text;
  final Widget widget;
  final IconData icon;

  const CustomInitialButton(this.text, this.widget, this.icon);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget))
      },
      child: Container(
        width: 150,
        height: 100,
        color: Colors.white60,
        child: Column(
          children: [
            Icon(icon, size: 70,),
            Text(text, style: TextStyle(fontSize: 12))
          ],
        ),
      ),
    );
  }

}