import 'package:apps/Pages/HabitTracker.dart';
import 'package:apps/Pages/choix_cat.dart';
import 'package:apps/Pages/cr%C3%A9ation_habitude.dart';
import 'package:apps/Pages/stats.dart';
import 'package:apps/module/habit.dart';
import 'package:flutter/material.dart';
import 'Pages/Home.dart';

void main() {

  List<Habit> habits = [];
  runApp(MaterialApp(
    initialRoute: '/',
    routes : {
      '/': (context) => Home(),
      '/categorie': (context) => Category(),
    },
  ));

}



