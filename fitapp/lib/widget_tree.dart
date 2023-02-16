import 'package:fitapp/auth.dart';
import 'package:fitapp/screen/login_register_screen.dart';
import 'package:fitapp/screen/parent_screen.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (
        context,
        snapshot,
      ) =>
          snapshot.hasData ? const ParentScreen() : const LoginScreen(),
    );
  }
}
