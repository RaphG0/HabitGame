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

      DateTime selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      if (tache.day != null) {
        DateTime Day = DateTime(tache.day!.year, tache.day!.month, tache.day!.day);
        if (selected.isBefore(Day) || selected.isAfter(Day)) {
          return false;
        }
      }
      if (tache.limit != null) {
        DateTime limit = DateTime(
            tache.limit.year, tache.limit.month, tache.limit.day);
        if (selected.isAfter(limit)){
          return false;
        }
      }
      // Si ce n’est pas le jour exact → on n’affiche pas


      // Sinon on garde la tâche
      return true;
    }).toList();

    List TachesPassees = widget.taches.where((tache) {
      // Jour de la tâche
      if (tache.limit == null) return false;
      DateTime selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      DateTime limit = DateTime(tache.limit.year,tache.limit.month,tache.limit.day);

      // Si ce n’est pas le jour exact → on n’affiche pas
      if (selected.isAfter(limit)){
        return true;
      }

      return false;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isChecked ? const Color(0xFFE8F5E9) : Colors.orange[200],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isChecked ? const Color(0xFFA5D6A7) : Colors.orange.shade200,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isChecked ? 0.03 : 0.06),
                            blurRadius: isChecked ? 4 : 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                activeColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    TachesForSelectedDay[index].joursReussis[todayKey] =
                                        newValue ?? false;
                                  });

                                  widget.onTachesChanged(widget.taches);
                                },
                              ),

                              Icon(
                                TachesForSelectedDay[index].category.icone,
                                color: isChecked
                                    ? Colors.green.shade700
                                    : TachesForSelectedDay[index].category.color,
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Text(
                                  TachesForSelectedDay[index].nom ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isChecked ? Colors.grey.shade600 : Colors.black87,
                                  ),
                                ),
                              ),

                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "modifier") {
                                    print("Modifier cliqué");
                                  } else if (value == "supprimer") {
                                    setState(() {
                                      widget.taches.remove(TachesForSelectedDay[index]);
                                    });

                                    widget.onTachesChanged(widget.taches);
                                  }
                                },
                                itemBuilder: (context) => const [
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

                          if (TachesForSelectedDay[index].limit != null) ...[
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 52),
                                child: Text(
                                  "À faire avant le "
                                      "${TachesForSelectedDay[index].limit.day}/"
                                      "${TachesForSelectedDay[index].limit.month}/"
                                      "${TachesForSelectedDay[index].limit.year}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isChecked ? Colors.grey.shade500 : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    if (isChecked)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: CustomPaint(
                              painter: StrikeThroughContainerPainter(),
                            ),
                          ),
                        ),
                      ),
                  ],
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
class StrikeThroughContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.65)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(16, size.height / 2),
      Offset(size.width - 16, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}