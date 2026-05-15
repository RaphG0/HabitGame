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




  Map<String, dynamic> toJson() {
    return {
      "nom": nom,
      "startDay": startDay?.toIso8601String(),
      "endDay": endDay?.toIso8601String(),
      "habits": habits?.map((h) => h.toJson()).toList(),
      "taches": taches?.map((t) => t.toJson()).toList(),
      "isDone": isDone,
      "isExpanded": isExpanded,
      "progression": progression,
    };
  }
  factory Goal.fromJson(Map json) {
    return Goal(
      nom: json["nom"],
      startDay: json["startDay"] != null
          ? DateTime.parse(json["startDay"])
          : null,
      endDay: json["endDay"] != null
          ? DateTime.parse(json["endDay"])
          : null,
      habits: (json["habits"] as List?)
          ?.map((h) => Habit.fromJson(h))
          .toList(),
      taches: (json["taches"] as List?)
          ?.map((t) => Tache.fromJson(t))
          .toList(),
      isDone: json["isDone"],
    )
      ..isExpanded = json["isExpanded"] ?? false
      ..progression = (json["progression"] as num?)?.toDouble() ?? 0.0;
  }
}

