import 'package:fitapp/screen/event_editing_screen.dart';
import 'package:fitapp/widget/exercise_widget.dart';
import 'package:fitapp/widget/reminder_widget.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../widget/calendar_widget.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({Key? key}) : super(key: key);

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  int index = 0;
  final screens = [
    const CalenderWidget(),
    const ReminderWidget(),
    const ExerciseWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitApp'),
        actions: [
          buildSignOutButton(),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
      body: buildScreen(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildScreen() {
    return screens[index];
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      currentIndex: index,
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
      onTap: (newIndex) {
        setState(() {
          index = newIndex;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_today_outlined,
          ),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.edit_notifications_outlined,
          ),
          label: 'Reminders',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.run_circle_outlined,
          ),
          label: 'Exercises',
        ),
      ],
    );
  }

  ElevatedButton buildSignOutButton() {
    return ElevatedButton.icon(
      onPressed: signOut,
      icon: const Icon(Icons.exit_to_app),
      label: const Text('Log Out'),
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
      ),
    );
  }

  FloatingActionButton? buildFloatingActionButton(BuildContext context) {
    return index == 0
        ? FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EventEditingScreen(),
              ),
            ),
          )
        : null;
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }
}
