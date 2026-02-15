import 'package:flutter/material.dart';
import 'package:pageui/config/themes/app_colors.dart';
import 'package:pageui/config/themes/app_text_style.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static String routeName = "HomeView";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(child: Text("data")),
      // drawerBarrierDismissible: false,
      // drawer
      body: Text("data"),
    );
  }
}
