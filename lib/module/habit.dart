import 'package:apps/module/cat.dart';
import 'package:flutter/cupertino.dart';
import 'package:apps/module/Goal.dart';

class Habit {
  //Property
  String? nom;
  bool? isDone;
  int? frequency;
  Cat category;
  DateTime? startDay;
  int? priority;
  String? goal;
  double? valeur_cible;
  bool curseur = false;
  String? modeMesure;
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

}