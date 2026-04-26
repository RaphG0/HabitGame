import 'package:flutter/material.dart';
import 'package:apps/module/habit.dart';

class HabitManager {
  //property
  List habits = [];

  //functions
  void add_habit(Habit habit){
    habits.add(habit);
  }

}


