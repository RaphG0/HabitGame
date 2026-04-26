import 'package:flutter/material.dart';
import 'package:apps/module/cat.dart';
import 'package:apps/Pages/creationObjectif.dart';
import 'package:apps/module/Goal.dart';

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

  List<String> sortOptions = ["Date de début", "Date de fin"];
  String? selectedSort;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
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
        backgroundColor: Colors.lightGreen[200],
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
                            onTap: () {
                              Navigator.pop(context);
                              // Action modifier
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
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(children: [Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          value: widget.objectifs[index].progression,
                          strokeWidth: 10,
                          color: Colors.purple,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      Text(
                        "${(widget.objectifs[index].progression * 100).toInt()}%",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text('${widget.objectifs[index].nom}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
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
                    return Column(children: [
                      InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(habit.category.icone),
                            Text("${habit.nom}",),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8,)
                    ]);
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
                Text("Tâches à venir",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                Column(
                  children: displayedTasks.map<Widget>((tache) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(tache.category.icone),
                            Text("${tache.nom}",),
                          ],
                        ),
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
