// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
//
// import '/model/event.dart';
//
// class EventProvider extends ChangeNotifier {
//   void addEvent(Event event) {
//     //_events.add(event);
//     notifyListeners();
//   }
//
//   void editEvent(Event newEvent, Event oldEvent) {
//     // final index = _events.indexOf(oldEvent);
//     // _events[index] = newEvent;
//     notifyListeners();
//   }
//
//   void deleteEvent(final key) {
//     final fireStoreReference = FirebaseFirestore.instance;
//     fireStoreReference.collection('events').doc(key).delete();
//
//     notifyListeners();
//   }
// }
