import 'dart:ui';

import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime beginAt;
  final DateTime endAt;
  final Color backgroundColor;
  final bool isAllDay;
  final bool isRepeating;
  final Duration repeatAfter;

  const Event({
    this.title = "",
    this.description = "",
    this.backgroundColor = Colors.orange,
    required this.beginAt,
    required this.endAt,
    this.isAllDay = false,
    this.isRepeating = false,
    this.repeatAfter = const Duration(seconds: 0),
  });
}
