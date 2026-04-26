import 'package:flutter/material.dart';
import 'package:apps/module/habit.dart';

class ExistantesT extends StatefulWidget {
  final List taches;
  final Function(List) onTaskChanged;

  const ExistantesT({
    super.key,
    required this.taches,
    required this.onTaskChanged,
  });

  @override
  State<ExistantesT> createState() => _ExistantesTState();
}

class _ExistantesTState extends State<ExistantesT> {
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
        itemCount: widget.taches.length,
        itemBuilder: (context, index) {
          final task = widget.taches[index];

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
                  Navigator.pop(context, task);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(task.category.icone, color: task.category.color),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          task.nom,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == "modifier") {
                            print("Modifier cliqué");
                          } else if (value == "supprimer") {
                            setState(() {
                              widget.taches.removeAt(index);
                            });
                            widget.onTaskChanged(widget.taches);
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