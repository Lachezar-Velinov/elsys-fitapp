import 'package:fitapp/screen/event_editing_screen.dart';
import 'package:fitapp/screen/reminder_editing_screen.dart';
import 'package:fitapp/widget/exercise_listview_widget.dart';
import 'package:fitapp/widget/reminder_listview_widget.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../widget/calendar_widget.dart';
import 'begin_exercise_screen.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({Key? key}) : super(key: key);

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  int index = 0;

  final screens = [
    const CalenderWidget(),
    const ReminderListViewWidget(),
    const ExerciseListView(),
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
    if (index == 0) {
      return buildAddEventButton(context);
    }
    if (index == 1) {
      return buildAddReminderButton(context);
    }
    return buildAddExerciseButton(context);
  }

  FloatingActionButton? buildAddEventButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.edit_calendar_outlined,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EventEditingScreen(),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  FloatingActionButton? buildAddReminderButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.notification_add_outlined,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ReminderEditingScreen(reminder: null),
        ),
      ),
    );
  }

  FloatingActionButton? buildAddExerciseButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.hourglass_bottom_outlined,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BeginExerciseScreen(),
        ),
      ),
    );
  }
}
