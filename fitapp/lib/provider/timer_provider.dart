import 'package:flutter/cupertino.dart';

class TimerProvider extends ChangeNotifier {
  Duration _duration = Duration();

  Duration get duration => _duration;

  void updateDuration({required Duration duration}) {
    _duration = duration;
    notifyListeners();
  }

  void addDuration({required Duration duration}) {
    _duration = _duration + duration;
    notifyListeners();
  }

  void resetDuration() {
    _duration = Duration();
    notifyListeners();
  }
}
