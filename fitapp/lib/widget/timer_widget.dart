import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/timer_provider.dart';
import '../utils.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) => Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                maxLines: 1,
                Utils.durationToTime(timerProvider.duration),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
