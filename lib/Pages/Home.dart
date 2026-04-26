import 'package:apps/Pages/stats.dart';
import 'package:flutter/material.dart';
import 'package:apps/Pages/création_habitude.dart';
import 'package:apps/Pages/choix_cat.dart';
import 'package:apps/module/habit.dart';
import 'package:apps/Pages/Taches_Manager.dart';
import 'package:apps/Pages/Objectifs.dart';
import 'package:apps/Pages/HabitTracker.dart';
import 'package:apps/Pages/Awards.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List habits = [];
  List taches = [];
  List objectifs = [];
  int _currentIndex = 0;
  // Liste des pages

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Tracker(
        habits: habits,
        onHabitsChanged: (updatedHabits) {
          setState(() {
            habits = updatedHabits;
          });
        },
      ),
      Objectifs(
        objectifs: objectifs,
        habits: habits,
        taches: taches,
        onHabitsChanged: (updatedHabits) {
          setState(() {
            habits = updatedHabits;
          });
        },
        onGoalChanged: (updatedGoal) {
          setState(() {
            objectifs = updatedGoal;
          });
        },
        onTaskChanged: (updatedTaches) {
          setState(() {
            taches = updatedTaches;
          });
        },
      ),
      Taches(
        taches: taches,
        onTachesChanged: (updatedTaches) {
          setState(() {
            taches = updatedTaches;
          });
        },
      ),
    ];
    return Scaffold(
      appBar : AppBar(
        title : Text('Organisation'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.grey[200],
      // MENU LATÉRAL
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // En-tête du menu
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                //crossaxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Icon(Icons.event, size: 50, color: Colors.lightBlue[30]),
                  SizedBox(height: 10),
                  Text(
                    "HabitGame",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Onglet Accueil
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Accueil"),
              onTap: () {
                Navigator.pop(context); // ferme le menu
              },
            ),

            // Onglet Stats
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Stats"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Stats(habits: habits)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Récompense"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Awards(habits: habits)),
                ); // ferme le menu
              },
            ),
          ],
        ),
      ),



      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: Colors.lightBlue[100],
        onTap: (index) {
        setState(() {
          _currentIndex = index; // changement de page
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.rule),
          label: "Habitudes",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.laptop),
          label: "Objectifs",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_box),
          label: "Tâches",
        ),
      ],
    ),
    );
  }
}
