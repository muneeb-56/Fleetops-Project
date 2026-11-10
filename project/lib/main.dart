import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'style.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WEB DATABASE
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // WINDOWS DATABASE
  else if (defaultTargetPlatform == TargetPlatform.windows) {
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;

    final directory = await getApplicationSupportDirectory();

    final dbPath = join(directory.path, 'databases');

    await databaseFactory.setDatabasesPath(dbPath);

    print('DATABASE LOCATION: $dbPath/fleetops.db');
  }

  // ANDROID: Uses the default sqflite factory.

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
