import 'package:hive/hive.dart';
import 'package:apps/module/habit.dart';
import 'package:apps/module/Tache.dart';
import 'package:apps/module/Goal.dart';

class StorageService {
  static final box = Hive.box('appBox');

  // 🔹 SAVE
  static void saveData({
    required List<Habit> habits,
    required List<Tache> taches,
    required List<Goal> goals,
  }) {
    box.put('habits', habits.map((h) => h.toJson()).toList());
    box.put('taches', taches.map((t) => t.toJson()).toList());
    box.put('goals', goals.map((g) => g.toJson()).toList());
  }

  // 🔹 LOAD
  static Map<String, dynamic> loadData() {
    return {
      'habits': box.get('habits', defaultValue: []),
      'taches': box.get('taches', defaultValue: []),
      'goals': box.get('goals', defaultValue: []),
    };
  }
}