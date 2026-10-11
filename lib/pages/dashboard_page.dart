import 'package:flutter/material.dart';

import 'package:capstone_website/widgets/global_appbar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    appBar: const GlobalAppBar(title: "Dashboard"),
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
