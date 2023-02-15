import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String key;

  const Event(
      {this.title = "",
      this.description = "",
      this.backgroundColor = Colors.orange,
      required this.beginAt,
      required this.endAt,
      this.isAllDay = false,
      this.isRepeating = false,
      this.repeatAfter = const Duration(seconds: 0),
      this.key = ""});

  static Event nullValuesConstructor(
      QueryDocumentSnapshot<Map<String, dynamic>> e) {
    DateTime beginAt = (e['beginAt'] as Timestamp).toDate();
    DateTime endAt = (e['endAt'] as Timestamp).toDate();
    return Event(
      title: e.data()['title'] ?? 'Error',
      beginAt: beginAt,
      endAt: endAt,
      isAllDay: false,
      key: e.id,
    );
  }


  static Event fromFireBaseSnapShotData(dynamic element, Color color) {
    return Event(
      beginAt: element.doc.data()?['beginAt'] ?? DateTime.now(),
      endAt: element.doc.data()?['beginAt'] ?? DateTime.now(),
      title: element.doc.data()?['title'] ?? '',
      key: element.doc.data()?['key'] ?? '',
    );
  }
}
