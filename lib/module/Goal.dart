import 'package:apps/module/cat.dart';
import 'package:flutter/cupertino.dart';
import 'package:apps/module/habit.dart';
import 'package:apps/module/Tache.dart';

class Goal {
  String? nom;
  DateTime? startDay;
  DateTime? endDay;
  List<Habit>? habits;
  List<Tache>? taches;
  bool? isDone;
  bool isExpanded = false;
  double progression = 0.5;

  Goal ({
    this.nom,
    this.startDay,
    this.endDay,
    this.habits,
    this.taches,
    this.isDone
});


}

