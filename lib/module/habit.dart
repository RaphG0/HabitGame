import 'package:apps/module/cat.dart';
import 'package:flutter/cupertino.dart';
import 'package:apps/module/Goal.dart';

class Habit {
  //Property
  String? nom;
  bool? isDone;
  int? frequency;
  Cat category;
  double pourcentage = 0;
  DateTime? startDay;
  int? priority;
  String? goal;
  double? valeur_cible;
  bool curseur = false;
  String? modeMesure;
  int? weeksucces = 0;
  String? nom_critere;
  List<int>? jours;
  int nbrParSemaine = 0;
  Set<String> semainesValidees = {};
  int? nbr_jours_reussis;
  int? nbr_jours_rates;
  String? critere_completion;
  Map<String, bool> joursReussis = {};
  Map<String, double> valeurs_curseurs = {};


  //Constructor
  Habit({
    required this.nom,
    this.isDone = false,
    required this.category,
    this.frequency,
    this.startDay,
    this.priority,
    this.modeMesure,
    this.critere_completion,
    this.jours,
    this.goal,
    this.nom_critere,
    this.valeur_cible,
    int? nbr_jours_reussis,
    Map<String, bool>? joursReussis,
    Map<String, double>? valeurs_curseurs
  }): nbr_jours_reussis = nbr_jours_reussis ?? 0,
      joursReussis = joursReussis ?? {},
      valeurs_curseurs = valeurs_curseurs ?? {};

  //functions
  void check(){
    isDone = true;
  }

  void uncheck(){
    isDone = false;
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'isDone': isDone,
      'frequency': frequency,
      'category': category.toJson(), // ⚠️ IMPORTANT
      'startDay': startDay?.toIso8601String(),
      'priority': priority,
      'goal': goal,
      'valeur_cible': valeur_cible,
      'curseur': curseur,
      'modeMesure': modeMesure,
      'nom_critere': nom_critere,
      'jours': jours,
      'nbrParSemaine': nbrParSemaine,
      'semainesValidees': semainesValidees.toList(),
      'nbr_jours_reussis': nbr_jours_reussis,
      'nbr_jours_rates': nbr_jours_rates,
      'critere_completion': critere_completion,
      'joursReussis': joursReussis,
      'valeurs_curseurs': valeurs_curseurs,
    };
  }

  factory Habit.fromJson(Map json) {
    return Habit(
      nom: json['nom'],
      isDone: json['isDone'],
      frequency: json['frequency'],
      category: Cat.fromJson(json['category']), // ⚠️ IMPORTANT
      startDay: json['startDay'] != null
          ? DateTime.parse(json['startDay'])
          : null,
      priority: json['priority'],
      goal: json['goal'],
      valeur_cible: (json['valeur_cible'] as num?)?.toDouble(),
      modeMesure: json['modeMesure'],
      nom_critere: json['nom_critere'],
      jours: (json['jours'] as List?)?.cast<int>(),
      nbr_jours_reussis: json['nbr_jours_reussis'],
      joursReussis: (json['joursReussis'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value as bool),
      ),
      valeurs_curseurs: (json['valeurs_curseurs'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
      ),
    )
      ..curseur = json['curseur'] ?? false
      ..nbrParSemaine = json['nbrParSemaine'] ?? 0
      ..nbr_jours_rates = json['nbr_jours_rates']
      ..critere_completion = json['critere_completion']
      ..semainesValidees = (json['semainesValidees'] as List?)
          ?.map((e) => e.toString())
          .toSet() ??
          {};
  }

}