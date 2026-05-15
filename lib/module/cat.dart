import 'package:flutter/material.dart';

class Cat {
  //Property
  String? nom;
  IconData? icone;
  Color? color;


  //Constructor
  Cat({
    required this.nom,
    this.icone,
    this.color
  });


  Map<String, dynamic> toJson() {
    return {
      'name': nom,
      'color': color,
      'icon': icone,
    };
  }

  factory Cat.fromJson(Map json) {
    return Cat(
      nom: json['name'],
      color: Color(json['color']),
      icone: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}