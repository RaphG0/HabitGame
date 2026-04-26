import 'package:flutter/material.dart';
import 'package:apps/module/habit.dart';

class Stats extends StatefulWidget {
  final List habits;
  const Stats({super.key, required this.habits});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes stats"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true
      ),
      body: Column(children: [
        Text("Nombre d'habitudes : ${widget.habits.length}"),
        Expanded(child: ListView.builder(
          itemCount: widget.habits.length,
          itemBuilder: (context, index) {
            int? nbrReussis = 0;
            int total_jours = 9;//today.difference(widget.habits[index].startDay).inDays;
            double pourcentage = widget.habits[index].nbr_jours_reussis/total_jours*100;
            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(children: [
                Text("${widget.habits[index].nom}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold
                ),
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Text("nbr de jour réussis : ${widget.habits[index].nbr_jours_reussis}"),
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Text("Pourcentage de réusite : ${double.parse(pourcentage.toStringAsFixed(1))}%")
                ),



            ]));
          },
        )),
      ],),
    );
  }
}
