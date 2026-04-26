import 'package:flutter/material.dart';
import 'package:apps/module/habit.dart';

class Existantes extends StatefulWidget {
  final List habits;
  final Function(List) onHabitsChanged;

  const Existantes({
    super.key,
    required this.habits,
    required this.onHabitsChanged,
  });

  @override
  State<Existantes> createState() => _ExistantesState();
}

class _ExistantesState extends State<Existantes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une habitude existante'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.habits.length,
        itemBuilder: (context, index) {
          final habit = widget.habits[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Action quand on clique sur la card
                  Navigator.pop(context, habit);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(habit.category.icone, color: habit.category.color),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          habit.nom,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == "modifier") {
                            print("Modifier cliqué");
                          } else if (value == "supprimer") {
                            setState(() {
                              widget.habits.removeAt(index);
                            });
                            widget.onHabitsChanged(widget.habits);
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}