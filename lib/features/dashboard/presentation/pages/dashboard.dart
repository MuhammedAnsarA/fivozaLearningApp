import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("DASHBOARD SCREEN"),
      ),
    );
  }
}
