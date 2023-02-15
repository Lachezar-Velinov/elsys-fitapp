import 'exercise.dart';

class AppUser {
  String name;
  String id;
  List<Exercise> exercises = List.empty(growable: true);

  AppUser({required this.name, required this.id});
}
