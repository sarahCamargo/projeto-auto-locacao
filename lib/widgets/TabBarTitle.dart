import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarTitle extends StatelessWidget {
  const TabBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context);

    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        String title = "Gerenciar Veículos"; // Título padrão
        if (tabController.index == 1) {
          title = "Gerenciar Manutenção";
        }
        return Text(title);
      },
    );
  }
}