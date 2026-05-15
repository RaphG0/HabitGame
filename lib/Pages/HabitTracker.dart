import 'package:apps/Pages/stats.dart';
import 'package:flutter/material.dart';
import 'package:apps/Pages/création_habitude.dart';
import 'package:apps/Pages/choix_cat.dart';
import 'package:apps/module/habit.dart';
import 'package:apps/Pages/Taches_Manager.dart';
import 'package:apps/Pages/Objectifs.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:apps/Pages/storage.dart';

class Tracker extends StatefulWidget {
  final List habits;
  final Function(List) onHabitsChanged;

  const Tracker({
    super.key,
    required this.habits,
    required this.onHabitsChanged,
  });

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {

  List<int> achievment = [7, 15, 30, 60, 90, 180, 365];
  DateTime selectedDate = DateTime.now();
  List<String> sortOptions = ["Nom", "Catégorie","Priorité","Complétion"];
  String? selectedSort;
  int? animatedIndex;
  late ConfettiController _confettiController;
  bool alreadyCelebratedToday = false;

  bool areAllHabitsChecked(List habitsForSelectedDay, String todayKey) {
    if (habitsForSelectedDay.isEmpty) return false;

    return habitsForSelectedDay.every((habit) {
      return habit.joursReussis[todayKey] == true;
    });
  }

  void checkAndCelebrate(List habitsForSelectedDay, String todayKey) {
    if (areAllHabitsChecked(habitsForSelectedDay, todayKey) &&
        !alreadyCelebratedToday) {
      _confettiController.play();
      alreadyCelebratedToday = true;
    }

    if (!areAllHabitsChecked(habitsForSelectedDay, todayKey)) {
      alreadyCelebratedToday = false;
    }
  }

  String _monthName(int month) {
    const months = [
      "Janvier", "Février", "Mars", "Avril",
      "Mai", "Juin", "Juillet", "Août",
      "Septembre", "Octobre", "Novembre", "Décembre"
    ];
    return months[month - 1];
  }

  void sortHabits(String? criterion) {
    if (criterion == "Nom") {
      widget.habits.sort((a, b) => a.nom.compareTo(b.nom));
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  DateTime getStartOfWeek(DateTime date) {
    int difference = date.weekday - 1; // lundi = 1
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: difference));
  }

  int countWeekSuccess(Habit habit, DateTime selectedDate) {
    DateTime startOfWeek = getStartOfWeek(selectedDate);
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    int count = 0;

    habit.joursReussis.forEach((dateString, isDone) {
      if (isDone) {
        DateTime date = DateTime.parse(dateString);

        if (!date.isBefore(startOfWeek) &&
            !date.isAfter(endOfWeek)) {
          count++;
        }
      }
    });

    return count;
  }

  void showWeeklySuccessPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("🎉 Bravo !"),
          content: Text("Habitude réussie pour la semaine !"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  void showAchievementPopup(int? nbr_jours) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 60),
              SizedBox(height: 10),
              Text("Bravo ! 🎉"),
            ],
          ),
          content: Text(
            "Tu as réussi $nbr_jours jours d'affilée ! Continue comme ça !",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Continuer"),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildHabitList() {
    List habitsForSelectedDay = widget.habits.where((habit) {
      DateTime habitStart = DateTime(
        habit.startDay.year,
        habit.startDay.month,
        habit.startDay.day,
      );

      DateTime selected = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      if (selected.isBefore(habitStart)) return false;

      if (habit.jours == null || habit.jours!.isEmpty) return true;

      return habit.jours!.contains(selectedDate.weekday);
    }).toList();

    for (var habit in habitsForSelectedDay) {
      habit.weeksucces = countWeekSuccess(habit, selectedDate);
    }

    return ListView.builder(
      key: ValueKey(selectedDate), // 🔥 TRÈS IMPORTANT
      itemCount: habitsForSelectedDay.length,
      itemBuilder: (context, index) {
        String todayKey = formatDate(selectedDate);

        bool isChecked = habitsForSelectedDay[index]
            .joursReussis[todayKey] ?? false;

        double value_cursor =
            habitsForSelectedDay[index].valeurs_curseurs[todayKey] ?? 0;

        return buildHabitItem(habitsForSelectedDay, index, todayKey, isChecked, value_cursor);
      },
    );
  }

  Widget buildHabitItem(habitsForSelectedDay, index, todayKey, isChecked, value_cursor){
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
                        final updatedHabit = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Creation(
                              selectedCategory: habitsForSelectedDay[index].category,
                              habitToEdit: habitsForSelectedDay[index], // 👈 on passe l’habitude
                            ),
                          ),
                        );
                        Navigator.pop(context);
                        if (updatedHabit != null){
                          setState(() {
                            int originalIndex = widget.habits.indexOf(habitsForSelectedDay[index]);
                            widget.habits[originalIndex] = updatedHabit;
                          });
                          widget.onHabitsChanged(widget.habits);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text("Supprimer"),
                      onTap: () {
                        setState(() {
                          widget.habits.removeAt(index);
                        });
                        widget.onHabitsChanged(widget.habits);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: AnimatedScale(
            scale: animatedIndex == index ? 1.05 : 1.0,
            duration: Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.elasticIn,

                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isChecked ? Colors.green.shade200 : Colors.purple[200],
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(50),   // Coin gauche très incurvé
                    right: Radius.circular(50),  // Coin droit très incurvé
                  ),
                ),
                child: Column(children: [Row(
                  children: [
                    RoundCheckBox(
                        isChecked : isChecked,
                        checkedColor: Colors.blue,
                        uncheckedColor: Colors.grey[300],
                        onTap: (bool? newValue){

                          setState(() {
                            if (newValue == true && isChecked == false) {
                              habitsForSelectedDay[index].nbr_jours_reussis += 1;

                            } else if (newValue == false && isChecked == true) {
                              habitsForSelectedDay[index].nbr_jours_reussis -= 1;
                            }
                            habitsForSelectedDay[index].joursReussis[todayKey] = newValue ?? false;
                            animatedIndex = index;
                          });

                          checkAndCelebrate(habitsForSelectedDay, todayKey);
                          Future.delayed(Duration(milliseconds: 180), () {
                            if (mounted) {
                              setState(() {
                                animatedIndex = null;
                              });
                            }
                          });

                          Habit habit = habitsForSelectedDay[index];
                          if (achievment.contains(habit.nbr_jours_reussis)) {
                            showAchievementPopup(habit.nbr_jours_reussis);
                          }

                          if (habit.modeMesure == "Nbr/semaine") {

                            int count = countWeekSuccess(habit, selectedDate);
                            DateTime startOfWeek = getStartOfWeek(selectedDate);

                            String weekKey = "${startOfWeek.year}-${startOfWeek.month}-${startOfWeek.day}";

                            if (!habit.semainesValidees.contains(weekKey) &&
                                count >= habit.frequency!) {
                              print(count);
                              showWeeklySuccessPopup();
                              habit.semainesValidees.add(weekKey);

                            }
                          }
                          widget.onHabitsChanged(widget.habits);
                        }),
                    Spacer(),
                    Text('${habitsForSelectedDay[index].nom}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    Icon(habitsForSelectedDay[index].category.icone,
                      color: habitsForSelectedDay[index].category.color,
                      size: 40,
                    ),

                  ],
                ),
                  if (habitsForSelectedDay[index].modeMesure == 'Nbr/semaine')
                    Text("${habitsForSelectedDay[index].weeksucces}/${habitsForSelectedDay[index].frequency}"),
                  if (habitsForSelectedDay[index].curseur == true)...[
                    if (habitsForSelectedDay[index].critere_completion == 'Pourcentage')...[
                      Column(
                        children: [
                          //Text("${habitsForSelectedDay[index].nom_critere} : ${value_cursor.round()}%"),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 6,
                              activeTrackColor: Colors.blue,
                              inactiveTrackColor: Colors.blue.shade100,
                              thumbColor: Colors.blue,
                              overlayColor: Colors.blue.withOpacity(0.15),

                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 11,
                                elevation: 3,
                              ),

                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 22,
                              ),

                              valueIndicatorColor: Colors.blue,
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),

                              showValueIndicator: ShowValueIndicator.always,
                            ),
                            child: Slider(
                              value: value_cursor,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label:
                              '${habitsForSelectedDay[index].nom_critere} : ${value_cursor.round()}%',
                              onChanged: (double v) {
                                setState(() {
                                  habitsForSelectedDay[index].valeurs_curseurs[todayKey] = v;
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("0%"),
                              Text("100%"),
                            ],
                          ),
                        ],
                      )],

                    if (habitsForSelectedDay[index].critere_completion == 'Quantité')
                      Column(
                        children: [
                          Text("Valeur : ${value_cursor.round()}"),

                          Slider(
                            value: value_cursor,
                            min: 0,
                            max: habitsForSelectedDay[index].valeur_cible,
                            onChanged: (double v) {
                              setState(() {
                                value_cursor = v;
                                habitsForSelectedDay[index].valeurs_curseurs[todayKey] = v;
                              });
                            },
                            activeColor: Colors.cyan,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${0}"),
                              Text("${habitsForSelectedDay[index].valeur_cible}"),
                            ],
                          ),
                        ],
                      )],
                ]))));
  }

  @override

  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  @override


  Widget build(BuildContext context) {

    List habitsForSelectedDay = widget.habits.where((habit) {
      // Si la date sélectionnée est avant le début → on n'affiche pas
      DateTime habitStart = DateTime(habit.startDay.year, habit.startDay.month, habit.startDay.day);
      DateTime selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

      if (selected.isBefore(habitStart)) {
        return false;
      }

      // Si aucun jour défini → affiché tous les jours
      if (habit.jours == null || habit.jours!.isEmpty) {
        return true;
      }

      // Sinon on vérifie si le jour correspond
      return habit.jours!.contains(selectedDate.weekday);

    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newHabit = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Category(),
            ),
          );

          if (newHabit != null) {
            setState(() {
              widget.habits.add(newHabit);
            });
            widget.onHabitsChanged(widget.habits);

            StorageService.saveData(
              habits: widget.habits.cast<Habit>(),
              taches: [],
              goals: [],
            );
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple[200],
      ),
      body: Stack(children: [Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.subtract(Duration(days: 1));
                    alreadyCelebratedToday = false;
                  });
                },
              ),

              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: Text(
                  "${selectedDate.day} ${_monthName(selectedDate.month)} ${selectedDate.year}",
                  key: ValueKey(selectedDate),
                  style: TextStyle(fontSize: 18),
                ),
              ),

              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.add(Duration(days: 1));
                    alreadyCelebratedToday = false;
                  });
                },
              ),
            ],
          ),
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
                sortHabits(newValue); // on appelle la fonction pour trier
              });
            },
          ),
          if (habitsForSelectedDay.isEmpty)...[
            Column(children: [Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 150, 30, 30),
                child: Icon(
                  Icons.edit_calendar,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            Text("Pas d'habitudes pour le moment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            )
            ])],
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(selectedDate.isAfter(DateTime.now()) ? 0.05 : -0.05, 0),
                      end: Offset(0, 0),
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildHabitList(),
            ),
          )
        ]
    ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.08,
            numberOfParticles: 50,
            maxBlastForce: 30,
            minBlastForce: 12,
            gravity: 0.25,
            shouldLoop: false,
            colors: const [
              Colors.blue,
              Colors.lightBlue,
              Colors.cyan,
              Colors.amber,
              Colors.orange,
              Colors.green,
              Colors.pink,
              Colors.purple,
            ],
          ),
        ),
      ]),);
  }
}
