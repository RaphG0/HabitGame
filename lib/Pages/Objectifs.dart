import 'package:flutter/material.dart';
import 'package:apps/module/cat.dart';
import 'package:apps/Pages/creationObjectif.dart';
import 'package:apps/module/Goal.dart';
import 'package:apps/module/habit.dart';

class Objectifs extends StatefulWidget {
  final List objectifs;
  final Function(List) onGoalChanged;

  final List habits;
  final Function(List) onHabitsChanged;

  final List taches;
  final Function(List) onTaskChanged;

  const Objectifs({
    super.key,
    required this.habits,
    required this.onHabitsChanged,
    required this.objectifs,
    required this.onGoalChanged,
    required this.taches,
    required this.onTaskChanged,
  });


  @override
  State<Objectifs> createState() => _ObjectifsState();
}

class _ObjectifsState extends State<Objectifs> {

  String formatDayKey(DateTime date) {
    return "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  double getHabitPercentageForToday(dynamic habit) {
    final todayKey = formatDayKey(DateTime.now());

    final value = habit.valeurs_curseurs[todayKey] ?? 0.0;

    return value.toDouble().clamp(0.0, 100.0);
  }

  double calculateGoalProgression(Goal goal) {
    if (goal.habits == null || goal.habits!.isEmpty) {
      return 0.0;
    }
    double totalPercentage = 0.0;
    if (goal.endDay != null){
      for (final habit in goal.habits!) {
        totalPercentage += calculateHabitSuccessPercentage(habit);
        Duration diff = goal.endDay!.difference(DateTime.now());
        int diffe = diff.inDays;
        totalPercentage = totalPercentage/diffe;
      }
    }

    final double averagePercentage = totalPercentage / goal.habits!.length;


    return (averagePercentage / 100).clamp(0.0, 1.0);
  }

  double calculateHabitSuccessPercentage(Habit habit) {
    final today = DateTime.now();

    final startDay = DateTime(
      habit.startDay!.year,
      habit.startDay!.month,
      habit.startDay!.day,
    );

    final currentDay = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final int totalJours = currentDay.difference(startDay).inDays + 1;

    if (totalJours <= 0) {
      return 0.0;
    }

    return habit.nbr_jours_reussis! / totalJours * 100;
  }

  List<String> sortOptions = ["Date de début", "Date de fin"];
  String? selectedSort;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
        floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newGoal = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreationObjectifs(habits: widget.habits,onHabitsChanged: widget.onHabitsChanged,taches: widget.taches, onTaskChanged: widget.onTaskChanged,),
            ),
          );

          if (newGoal != null) {
            setState(() {
              widget.objectifs.add(newGoal);
            });
            widget.onGoalChanged(widget.objectifs);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue[200],
      ),
      body: Column(children: [
        DropdownButton<String>(
        value: selectedSort,
        hint: Text("Trier par"),
        items: sortOptions.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedSort = newValue;
          });
        },
      ),
        if (widget.objectifs.isEmpty)...[
          Column(children: [Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 150, 30, 30),
              child: Icon(
                Icons.flag,
                size: 100,
                color: Colors.grey,
              ),
            ),
          ),
            Text("Pas d'objectifs pour le moment",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            )
          ])],
        Expanded(child: ListView.builder(
        itemCount: widget.objectifs.length,
        itemBuilder: (context, index) {
          bool isChecked = widget.objectifs[index].isDone ?? false;
          final displayedHabits = widget.objectifs[index].isExpanded ? widget.objectifs[index].habits
              : widget.objectifs[index].habits.take(2).toList();
          final displayedTasks = widget.objectifs[index].taches;
          final goal = widget.objectifs[index];
          final double progression = calculateGoalProgression(goal);
          return GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text("Modifier"),
                            onTap: () async {
                              final updatedGoal = await Navigator.push(
                                context,
                                  MaterialPageRoute(
                                    builder: (context) => CreationObjectifs(
                                      habits: widget.habits,
                                      onTaskChanged: widget.onTaskChanged,
                                      taches: widget.taches,
                                      onHabitsChanged: widget.onHabitsChanged,
                                      goalToEdit: widget.objectifs[index],
                                    )
                                  ),
                              );
                              Navigator.pop(context);

                              if (updatedGoal != null){
                                setState(() {
                                  int originalIndex = widget.objectifs.indexOf(widget.objectifs[index]);
                                  widget.objectifs[originalIndex] = updatedGoal;
                                });
                                widget.onGoalChanged(widget.objectifs);
                              }
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text("Supprimer"),
                            onTap: () {
                              setState(() {
                                widget.objectifs.removeAt(index);
                              });
                              widget.onGoalChanged(widget.objectifs);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child:
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFEAF7FF),
                    border: Border.all(color: const Color(0xFFB9E6FF)),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 55,
                                height: 55,
                                child: CircularProgressIndicator(
                                  value: progression,
                                  strokeWidth: 6,
                                  color: Colors.deepPurple,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                              Text(
                                "${(progression * 100).toInt()}%",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              widget.objectifs[index].nom ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // 👇 CARD DATES COMPACTE
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // 🔥 important
                          children: [
                            Text("Début: ${widget.objectifs[index].startDay.day}/${widget.objectifs[index].startDay.month}"),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, size: 16),
                            SizedBox(width: 10),
                            if (widget.objectifs[index].endDay != null)
                              Text(
                                "Fin: ${widget.objectifs[index].endDay.day}/${widget.objectifs[index].endDay.month}",
                              )
                            else
                              const Text("Fin : AUCUNE"),
                          ],
                        ),
                      ),
              if (widget.objectifs[index].habits.isNotEmpty)...[
                SizedBox(height: 10,),
                Text("Habitudes associées :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
                SizedBox(height: 10,),
                Column(
                  children: displayedHabits.map<Widget>((habit) {
                    return Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            habit.category.icone,
                            size: 20,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              habit.nom ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${calculateHabitSuccessPercentage(habit).toStringAsFixed(1)}%",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (widget.objectifs[index].habits.length > 2)
                TextButton.icon(
                    onPressed: (){
                      setState(() {
                        widget.objectifs[index].isExpanded = !widget.objectifs[index].isExpanded;
                      });
                    },
                    icon: Icon(widget.objectifs[index].isExpanded ? Icons.expand_less : Icons.expand_more),
                    label: Text(widget.objectifs[index].isExpanded ? "Voir moins" : "Voir plus")
                )],
                if (widget.objectifs[index].taches.isNotEmpty)...[
                SizedBox(height: 10),
                Row(children: [
                  Text("Tâches à venir",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 60),
                  Expanded(child: Text(
                    "Taches réussies : 0/${displayedTasks.length}"
                  ))
                ]),
                  Column(
                    children: displayedTasks.map<Widget>((tache) {
                      return Container(
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(tache.category.icone, size: 18, color: Colors.orange),
                            SizedBox(width: 10),
                            Text(tache.nom ?? ""),
                          ],
                        ),
                      );
                    }).toList(),
                  ),]
              ])));

        },
      )),])
    );
  }
}
