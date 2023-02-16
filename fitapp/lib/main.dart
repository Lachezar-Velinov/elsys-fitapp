import 'package:firebase_core/firebase_core.dart';
import 'package:fitapp/widget_tree.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      themeMode: ThemeMode.light,
      home: const WidgetTree(),
    );
  }
}
