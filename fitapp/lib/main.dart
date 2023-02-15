import 'package:firebase_core/firebase_core.dart';
import 'package:fitapp/screen/event_editing_screen.dart';
import 'package:fitapp/widget_tree.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'widget/calendar_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return /*ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: */
        MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      themeMode: ThemeMode.light,
      home: const WidgetTree(),
      /*),*/
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitApp'),
        actions: [
          ElevatedButton.icon(
            onPressed: signOut,
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Log Out'),
            style: ElevatedButton.styleFrom(shadowColor: Colors.transparent),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: const CalenderWidget(),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const EventEditingScreen())),
    );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }
}
