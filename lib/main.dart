import 'dart:io';

import 'package:clothes_shop/pages/android/home_screen.dart' as android;
import 'package:clothes_shop/pages/web/home_screen.dart' as web;
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: (Platform.isAndroid) ? const android.HomeScreen() : const web.HomeScreen(),
    );
  }
}
