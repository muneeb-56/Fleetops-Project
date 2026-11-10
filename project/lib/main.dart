import 'package:flutter/material.dart';
import 'style.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const FleetOpsApp());
}

class FleetOpsApp extends StatelessWidget {
  const FleetOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FleetOps',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginPage(),
    );
  }
}