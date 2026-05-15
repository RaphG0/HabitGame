import 'package:apps/module/cat.dart';
import 'package:flutter/cupertino.dart';

class Tache {
  //Property
  String? nom;
  bool? isDone;
  Cat? category;
  String? goal;
  DateTime? day;
  DateTime? limit;
  int? priority;
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
  Tache({
    required this.nom,
    this.isDone = false,
    this.category,
    this.day,
    this.limit,
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
  })
      : nbr_jours_reussis = nbr_jours_reussis ?? 0,
        joursReussis = joursReussis ?? {},
        valeurs_curseurs = valeurs_curseurs ?? {};

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'isDone': isDone,
      'category': category!.toJson(), // ⚠️ IMPORTANT
      'Day': day,
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

  factory Tache.fromJson(Map json) {
    return Tache(
      nom: json['nom'],
      isDone: json['isDone'],
      category: Cat.fromJson(json['category']), // ⚠️ IMPORTANT
      day: json['Day'] != null
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