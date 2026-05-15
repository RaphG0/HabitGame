import 'package:apps/module/habit.dart';
import 'package:flutter/material.dart';
import 'package:apps/module/Tache.dart';
import 'package:apps/module/cat.dart';

class Creationtache extends StatefulWidget {
  final Cat selectedCategory;
  const Creationtache({super.key,
    required this.selectedCategory,
  });

  @override
  State<Creationtache> createState() => _CreationtacheState();
}

class _CreationtacheState extends State<Creationtache> {

  TextEditingController nomcontroller = TextEditingController();
  String? date_debut;
  String? completeion_c;
  String? nom;
  Cat? cat;
  List <String> debut1 = ["Aujourd'hui", "Choisir un jour"];
  List <String> debut2 = ["Demain", "Choisir un jour"];
  List<String> completion = ["Pour le", "Avant le"];
  DateTime? datedebuttache;
  DateTime? limit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvelle Tâche"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          TextField(
            controller: nomcontroller,
            decoration: const InputDecoration(
              labelText: "Entrez le nom de la tâche",
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
                    value: completeion_c,
                    hint: Text("A faire"),
                    isExpanded: true,
                    menuMaxHeight: 200,
                    items: completion.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      setState(() {
                        completeion_c = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          if (completeion_c == "Pour le")...[
            SizedBox(height: 15),
            Text("Choisir un jour",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
            ),
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
                    hint: Text("Date"),
                    isExpanded: true,
                    menuMaxHeight: 200,
                    items: debut1.map((option) {
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
                            datedebuttache = DateTime.now();
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
                              datedebuttache = date;
                            });
                          }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
            SizedBox(height: 15),
          ],
          if (completeion_c == "Avant le")...[
            SizedBox(height: 15),
            Text("Choisir un jour",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
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
                      hint: Text("Date"),
                      isExpanded: true,
                      menuMaxHeight: 200,
                      items: debut2.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        setState(() {
                          date_debut = newValue;
                        });

                        if (date_debut == "Demain") {
                          setState(() {
                              limit = DateTime.now().add(const Duration(days: 1));
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
                                limit = date;
                              });
                            }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
          ElevatedButton(
            onPressed: (){
              nom =nomcontroller.text;
              cat = widget.selectedCategory;
              final Tache newtache = Tache(nom: nom,
                  category: cat,
                  isDone: false,
                  day: datedebuttache,
                  limit: limit
              );
              Navigator.pop(context, newtache);
            },
            child: Text('Valider'),),
        ],
      ),

    );
  }
}
