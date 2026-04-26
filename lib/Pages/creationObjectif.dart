import 'package:apps/Pages/choix_cat_tache.dart';
import 'package:flutter/material.dart';
import 'package:apps/module/cat.dart';
import 'package:apps/Pages/Objectifs.dart';
import 'package:apps/module/Goal.dart';
import 'package:apps/Pages/choix_cat.dart';
import 'package:apps/module/habit.dart';
import 'package:apps/module/cat.dart';
import 'package:apps/Pages/ajoutHabitExistante.dart';
import 'package:apps/module/Tache.dart';
import 'package:apps/Pages/ajoutTacheExistante.dart';

class CreationObjectifs extends StatefulWidget {
  final List habits;
  final Function(List) onHabitsChanged;
  final List taches;
  final Function(List) onTaskChanged;

  const CreationObjectifs({
    super.key,
    required this.habits,
    required this.onHabitsChanged,
    required this.taches,
    required this.onTaskChanged,
  });

  @override
  State<CreationObjectifs> createState() => _CreationObjectifsState();
}

class _CreationObjectifsState extends State<CreationObjectifs> {
  TextEditingController nameController = TextEditingController();
  String? mode_date_debut;
  String? mode_date_fin;
  DateTime? date_debut;
  DateTime? date_fin;
  List<String> debut = ["Aujourd'hui", "Choisir un jour"];
  List<String> fin = ["Aucune", "Choisir un jour"];
  List<Habit> associatedHabits = [];
  List<Tache> associatedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvel objectif"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(child:
      Column(
        children: [
          SizedBox(height: 20.0),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Entrez le nom de l'objectif",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [Expanded(child:
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
                        value: mode_date_debut,
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
                            mode_date_debut = newValue;
                          });

                          if (mode_date_debut == "Aujourd'hui") {
                            setState(() {
                              date_debut = DateTime.now();
                            });
                          } else if (mode_date_debut == "Choisir un jour") {
                            final DateTime? date_d = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (date_d != null) {
                              setState(() {
                                date_debut = date_d;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),),
              Expanded(child: Container(
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
                        value: mode_date_fin,
                        hint: Text("Date de fin"),
                        isExpanded: true,
                        menuMaxHeight: 200,
                        items: fin.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          setState(() {
                            mode_date_fin = newValue;
                          });

                          if (mode_date_fin == "Aucune") {
                            setState(() {
                              date_fin = null;
                            });
                          } else if (mode_date_fin == "Choisir un jour") {
                            final DateTime? date_f = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (date_f != null) {
                              setState(() {
                                date_fin = date_f;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              )],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final newHabit = await Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => Category(),
                    ),
                    );
                    if (newHabit != null) {
                    setState(() {
                      newHabit.goal = nameController.text;
                      widget.habits.add(newHabit);
                      associatedHabits.add(newHabit);
                    });
                    widget.onHabitsChanged(widget.habits);
                    }
                    },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.add_circle_outline, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "Créer une habitude a associer",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final newHabit = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Existantes(habits: widget.habits, onHabitsChanged: widget.onHabitsChanged),
                      ),
                    );
                    setState(() {
                      associatedHabits.add(newHabit);
                    });

                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.link, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "Associer une habitude existante",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(
              maxHeight: 250, // hauteur max de la zone
            ),
            child: associatedHabits.isEmpty
                ? Center(
              child: Text(
                "Aucune habitude associée",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true, // ne prend que la place nécessaire
              itemCount: associatedHabits.length,
              itemBuilder: (context, index) {
                final habit = associatedHabits[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  child: ListTile(
                    leading: Icon(
                      habit.category.icone,
                      color: habit.category.color,
                    ),
                    title: Text(habit.nom ?? ""),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          associatedHabits.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final newTache = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryTache(),
                      ),
                    );
                    if (newTache != null) {
                      setState(() {
                        newTache.goal = nameController.text;
                        widget.taches.add(newTache);
                        associatedTasks.add(newTache);
                      });
                      widget.onTaskChanged(widget.taches);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.add_circle_outline, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "Créer une tâche a associer",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final newTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExistantesT(taches: widget.taches, onTaskChanged: widget.onTaskChanged),
                      ),
                    );
                    setState(() {
                      associatedTasks.add(newTask);
                    });

                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.link, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "Associer une tâche existante",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(
              maxHeight: 250, // hauteur max de la zone
            ),
            child: associatedTasks.isEmpty
                ? Center(
              child: Text(
                "Aucune tâche associée",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true, // ne prend que la place nécessaire
              itemCount: associatedTasks.length,
              itemBuilder: (context, index) {
                final tache = associatedTasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  child: ListTile(
                    leading: Icon(
                      tache.category!.icone,
                      color: tache.category!.color,
                    ),
                    title: Text(tache.nom ?? ""),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          associatedTasks.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: (){
              final Goal newGoal = Goal(nom: nameController.text,
                  isDone: false,
                  startDay: date_debut,
                  endDay: date_fin,
                  habits: associatedHabits,
                  taches : associatedTasks
              );
              Navigator.pop(context, newGoal);
            },
            child: Text('Valider'),),
        ],
      ),),
    );
  }
}