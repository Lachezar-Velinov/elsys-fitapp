import 'dart:async';

import 'package:fitapp/provider/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/timer_widget.dart';

class BeginExerciseScreen extends StatefulWidget {
  const BeginExerciseScreen({Key? key}) : super(key: key);

  @override
  State<BeginExerciseScreen> createState() => _BeginExerciseScreenState();
}

class _BeginExerciseScreenState extends State<BeginExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerProvider>(
      create: (context) => TimerProvider(),
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Expanded(
              child: TimerWidget(),
            ),
            Flexible(
              child: StartTimerButton(),
            ),
          ],
        ),
        appBar: AppBar(
          leading: const CloseButton(),
          actions: const [],
        ),
      ),
    );
  }
}

class StartTimerButton extends StatefulWidget {
  const StartTimerButton({
    Key? key,
  }) : super(key: key);

  @override
  State<StartTimerButton> createState() => _StartTimerButtonState();
}

class _StartTimerButtonState extends State<StartTimerButton> {
  //bool isActive = false;

  Timer? timer;

  void _startTimer(TimerProvider timerProvider) {
    Duration duration = const Duration(milliseconds: 100);
    timer = Timer.periodic(
      duration,
      (_) {
        timerProvider.addDuration(duration: duration);
      },
    );
  }

  void _touchButton(TimerProvider timerProvider) {
    if (timer != null) {
      if (timer!.isActive) {
        timer!.cancel();

        return;
      }
    }
    _startTimer(timerProvider);
  }

  String gameButtonText() {
    if (timer != null) {
      return 'Start';
    }
    if (!timer!.isActive) {
      return 'Start';
    }
    return 'Stop';
  }

  @override
  Widget build(BuildContext context) {
    TimerProvider timerProvider = Provider.of<TimerProvider>(
      context,
      listen: false,
    );

    return TextButton(
      onPressed: () {
        _touchButton(timerProvider);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(gameButtonText()),
          const Icon(Icons.not_started),
        ],
      ),
    );
  }
}
