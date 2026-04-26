import 'package:apps/module/habit.dart';
import 'package:flutter/material.dart';
import 'package:apps/module/habit.dart';
import 'package:apps/module/habit_manager.dart';
import 'package:apps/module/cat.dart';

class Creation extends StatefulWidget {
  final Cat selectedCategory;
  final Habit? habitToEdit;
  const Creation({super.key,
    required this.selectedCategory,
    this.habitToEdit
  });

  @override
  State<Creation> createState() => _CreationState();
}

class _CreationState extends State<Creation> {

  void initState() {
    super.initState();

    if (widget.habitToEdit != null) {
      final habit = widget.habitToEdit!;

      nameController.text = habit.nom!;
      freq = habit.frequency ?? 7;
      mode = habit.modeMesure;
      critere = habit.critere_completion;
      nom_critere = habit.nom_critere;
      valeur_cible = habit.valeur_cible;
      cursor = habit.curseur;
      datedebuthabit = habit.startDay;

      if (critere == "Pourcentage") {
        critereNomPController.text = habit.nom_critere ?? "";
      }

      if (critere == "Quantité") {
        critereNomQController.text =
            habit.valeur_cible?.toString() ?? "";
      }
    }
  }

TextEditingController nameController = TextEditingController();
TextEditingController freqController = TextEditingController();
TextEditingController typeController = TextEditingController();
TextEditingController critereNomPController = TextEditingController();
TextEditingController critereNomQController = TextEditingController();
TextEditingController critereValeurController = TextEditingController();
String nom = "";
double? valeur_cible;
String? nom_critere;
int freq = 7;
String? mode;
String? critere;
Cat cat = Cat(nom:"temp");
List <String> criteres_option = ["OUI/NON","Pourcentage", "Quantité", "Autre"];
List <String> mode_option = ['Nbr/semaine', 'Certains jours','7jours/7'];
List<int> freq_option = [1,2,3,4,5,6];
List<String> jours_option = ['Lu','Ma','Me','Je','Ve','Sa','Di'];
Map<String,int> correspondance = {
  'Lu' :1,'Ma' :2,'Me' :3,'Je' :4,'Ve' :5,'Sa' :6,'Di' :7,
};
String? date_debut;
List <String> debut = ["Aujourd'hui", "Choisir un jour"];

bool cursor = false;
DateTime? datedebuthabit;

  @override
  Widget build(BuildContext context) {
    List<int> jours_habit = [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Création d'habitudes"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body:Column(
        children: [
          SizedBox(height: 20.0),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Entrez le nom de l'habitude",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            width: 300,
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: date_debut,
                    hint: Text("Date de début"),
                    isExpanded: true,
                    menuMaxHeight: 200,
                    items: debut.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      setState(() {
                        date_debut = newValue;
                      });

                      if (date_debut == "Aujourd'hui") {
                        setState(() {
                          datedebuthabit = DateTime.now();
                        });
                      }
                      else if (date_debut == "Choisir un jour") {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (date != null) {
                          setState(() {
                            datedebuthabit = date;
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          if (datedebuthabit != null)...[
            Text(
              "Date de début de l'habitude : ${datedebuthabit != null ? '${datedebuthabit!.day}/0${datedebuthabit!.month}/${datedebuthabit!.year}' : ''}",
            ),
          SizedBox(height: 20),
          Text(
            "Méthode d'évaluation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          SizedBox(height: 10),
          Text("Choix du critère à évaluer", textAlign: TextAlign.left,),
          SizedBox(height: 20),
            Container(
              width: 300,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: critere,
                        hint: Text("Choix d'un critère de complétion"),
                        items: criteres_option.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            critere = newValue;
                            if (critere != "OUI/NON"){
                              cursor = true;
                            }
                          });
                        }
                    ),
                  ),
                ),
              ),
            ),

          if (critere != null)...[
          if (critere == "Pourcentage")...[
            SizedBox(height: 30),
            Text("Critères évalué :"),
            TextField(
              controller: critereNomPController,
              decoration: const InputDecoration(
                labelText: "Nom du critère",
                border: OutlineInputBorder(),
              ),
            )
          ],
          if (critere == "Quantité") ...[
            SizedBox(height: 30),
            Text("Critères évalué :"),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: critereNomQController,
                    decoration: const InputDecoration(
                      labelText: "Valeur cible",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10), // un peu d'espace entre les champs
                Expanded(
                  child: TextField(
                    controller: critereValeurController,
                    decoration: const InputDecoration(
                      labelText: "Unité",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // si c'est un nombre
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 30),
            Container(
              width: 300,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: mode,
                        hint: Text("Fréquence de l'habitude"),
                        items: mode_option.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            mode = newValue;
                          });
                        }
                    ),
                  ),
                ),
              ),
            ),

          SizedBox(height: 20.0),
          if (mode == 'Nbr/semaine')
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: freq_option.map((f) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      freq = f;
                    });
                  },
                  child: Text('$f'),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(15),
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 20),
          if (mode == 'Certains jours') ...[
            Text('Choix des jours:'),
            SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: jours_option.map((jour) {
                return ElevatedButton(
                  onPressed: () {
                    jours_habit.add(correspondance[jour]!);
                    //freq = freq + 1;
                  },
                  child: Text(jour),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(15),
                  ),
                );
              }).toList(),
            ),
          ],
          ElevatedButton(
              onPressed: (){
                nom =nameController.text;
                cat = widget.selectedCategory;
                if (critere == 'Pourcentage') {
                  nom_critere = critereNomPController.text;
                }
                if (critere == 'Quantité') {
                  valeur_cible = double.parse(critereNomQController.text);
                }
                if (widget.habitToEdit != null) {
                  // ✏️ MODE MODIFICATION
                  final habit = widget.habitToEdit!;

                  habit.nom = nameController.text;
                  habit.frequency = freq;
                  habit.category = widget.selectedCategory;
                  habit.startDay = datedebuthabit;
                  habit.modeMesure = mode;
                  habit.critere_completion = critere;
                  habit.valeur_cible = valeur_cible;
                  habit.nom_critere = nom_critere;
                  habit.curseur = cursor;

                  Navigator.pop(context, habit);
                } else {
                  // ➕ MODE CRÉATION
                  final Habit newHabit = Habit(
                    nom: nameController.text,
                    frequency: freq,
                    category: widget.selectedCategory,
                    isDone: false,
                    startDay: datedebuthabit,
                    jours: jours_habit,
                    modeMesure: mode,
                    critere_completion: critere,
                    valeur_cible: valeur_cible,
                    nom_critere: nom_critere,
                  );

                  newHabit.curseur = cursor;

                  Navigator.pop(context, newHabit);
                }
                },
              child: Text('Valider'),),
        ]]],
      ),
    );
  }
}
