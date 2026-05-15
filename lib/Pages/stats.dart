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
            int total_jours = today.difference(widget.habits[index].startDay).inDays +1;
            double pourcentage = widget.habits[index].nbr_jours_reussis / total_jours * 100;
            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(children: [
                Text("${widget.habits[index].nom}",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
                ),
              Row(children: [
                Expanded(child: Column(children: [
                  Text("Nbr de jour réussis : ${widget.habits[index].nbr_jours_reussis}",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("${widget.habits[index].nbr_jours_reussis}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),
                  )
                ],),),
                SizedBox(width: 10),
                Container(
                  width: 2,
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(child: Column(children :[
                Text("Pourcentage de réusite : ",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                  SizedBox(height: 5),
                  Text("${double.parse(pourcentage.toStringAsFixed(1))}%",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  )
                ]),
                )
              ],)
              ]));
          },
        )),
      ],),
    );
  }
}
