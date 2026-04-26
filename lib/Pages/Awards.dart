import 'package:flutter/material.dart';
import 'package:apps/module/habit.dart';

class Awards extends StatefulWidget {
  final List habits;
  const Awards({super.key, required this.habits});

  @override
  State<Awards> createState() => _AwardsState();
}

class _AwardsState extends State<Awards> {
  @override
  Widget build(BuildContext context) {
    // Couleurs
    final Color outerBorderColor = Colors.blueAccent;
    final Color innerBorderColor = Colors.lightGreenAccent;
    final Color outerBackgroundColor = Colors.blue[100]!; // bleu pâle pour le grand container

    // Taille des petits containers
    final double smallSize = 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Récompenses'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.habits.length,
              itemBuilder: (context, index) {
                int total_jours = 9; //today.difference(widget.habits[index].startDay).inDays;
                double pourcentage = widget.habits[index].nbr_jours_reussis / total_jours * 100;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: outerBackgroundColor, // fond bleu pâle
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text("${widget.habits[index].nom}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (i) {
                        return Container(
                          width: smallSize,
                          height: smallSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: innerBorderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "?",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),])
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}