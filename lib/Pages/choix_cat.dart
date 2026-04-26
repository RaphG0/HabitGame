import 'package:apps/Pages/cr%C3%A9ation_habitude.dart';
import 'package:flutter/material.dart';
import 'package:apps/module/cat.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  List<Cat> cat = [
    Cat(nom: 'Santé', icone: Icons.health_and_safety_outlined, color: Colors.lightGreen),
    Cat(nom: 'Sport', icone: Icons.sports, color: Colors.lightBlue),
    Cat(nom: 'Professionnel', icone: Icons.work, color: Colors.yellow[200]),
    Cat(nom: 'Intellectuel', icone: Icons.school, color: Colors.orange[600]),
    Cat(nom: 'Organisation', icone: Icons.schema, color: Colors.grey[600]),
    Cat(nom: 'Quitter une habitude', icone: Icons.stop, color: Colors.red[200])
  ];

  Cat? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Catégorie'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cat.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () async {
                      final habit = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Creation(
                            selectedCategory: cat[index],
                          )
                        ),
                      );
                      if (habit != null){
                        Navigator.pop(context, habit);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: cat[index].color,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${cat[index].nom}'),
                          Icon(cat[index].icone),
                        ],
                      ),
                    ),
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