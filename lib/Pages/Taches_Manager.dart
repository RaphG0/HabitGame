import 'package:apps/Pages/choix_cat_tache.dart';
import 'package:flutter/material.dart';
import 'package:apps/module/cat.dart';
import 'package:apps/Pages/choix_cat.dart';
import 'package:apps/module/Tache.dart';

class Taches extends StatefulWidget {
  final List taches;
  final Function(List) onTachesChanged;

  const Taches({
  super.key,
  required this.taches,
  required this.onTachesChanged,});

  @override
  State<Taches> createState() => _TachesState();
}

class _TachesState extends State<Taches> {

  List<int> achievment = [7, 15, 30, 60, 90, 180, 365];
  DateTime selectedDate = DateTime.now();
  List<String> sortOptions = ["Nom", "Catégorie","Priorité","Complétion"];
  String? selectedSort;

  String _monthName(int month) {
    const months = [
      "Janvier", "Février", "Mars", "Avril",
      "Mai", "Juin", "Juillet", "Août",
      "Septembre", "Octobre", "Novembre", "Décembre"
    ];
    return months[month - 1];
  }

  String formatDate(DateTime date) {
    String format = "";
    if (date.day < 10){
      format = "${date.year}-0${date.month}-0${date.day}";
    }else{
      format = "${date.year}-0${date.month}-${date.day}";
    }
    return format;
  }

  DateTime getStartOfWeek(DateTime date) {
    int difference = date.weekday - 1; // lundi = 1
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: difference));
  }

  @override
  Widget build(BuildContext context) {

    List TachesForSelectedDay = widget.taches.where((tache) {
      // Jour de la tâche
      DateTime Day = DateTime(tache.day.year, tache.day.month, tache.day.day);
      DateTime selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

      // Si ce n’est pas le jour exact → on n’affiche pas
      if (selected.isBefore(Day) || selected.isAfter(Day)) {
        return false;
      }

      // Sinon on garde la tâche
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.subtract(Duration(days: 1));
                  });
                },
              ),
              Text(
                "${(selectedDate).day} "
                    "${_monthName(selectedDate.month)} "
                    "${selectedDate.year}",
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate.add(Duration(days: 1));
                  });
                },
              ),
            ],
          ),
          if (widget.taches.isEmpty)...[
            Column(children: [Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 150, 30, 30),
                child: Icon(
                  Icons.check_box,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
              Text("Pas de tâches pour le moment",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              )
            ])],
          Expanded(
            child: ListView.builder(
              itemCount: TachesForSelectedDay.length,
              itemBuilder: (context, index) {
                String todayKey = formatDate(selectedDate);
                bool isChecked = TachesForSelectedDay[index]
                    .joursReussis[todayKey] ?? false;
                double value_cursor =
                    TachesForSelectedDay[index].valeurs_curseurs[todayKey] ?? 0;
                return Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? newValue){
                              setState(() {
                                TachesForSelectedDay[index].joursReussis[todayKey] = newValue ?? false;
                              });
                              Tache tache = TachesForSelectedDay[index];
                            },
                          ),
                          Icon(TachesForSelectedDay[index].category.icone),
                          Text('${TachesForSelectedDay[index].nom}'),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == "modifier") {
                                print("Modifier cliqué");
                              } else if (value == "supprimer") {
                                setState(() {
                                  widget.taches.removeAt(index);
                                });
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: "modifier",
                                child: Text("Modifier"),
                              ),
                              PopupMenuItem(
                                value: "supprimer",
                                child: Text("Supprimer"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTache = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryTache(),
            ),
          );
          if (newTache != null) {
            setState(() {
              widget.taches.add(newTache);
            });
          }
        },
        backgroundColor: Colors.orange[200],
        child: Icon(Icons.add),
      ),
    );
  }
}
