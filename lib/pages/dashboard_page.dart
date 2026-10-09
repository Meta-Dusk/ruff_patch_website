import 'package:capstone_website/widgets/global_appbar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: GlobalAppBar(title: "Dashboard"),
      body: Center(
        child: Text(
          'User Progress & Analytics will go here.',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
