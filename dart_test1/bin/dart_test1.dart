import 'dart:io';

void main(List<String> arguments) {
  print("Entrée votre nom d'utilisateur : ");
  String? username1 = stdin.readLineSync();
  print("Entrée votre age :");
  String? age1 = stdin.readLineSync();
  int? entier = int.tryParse(age1 ?? "");
  if (entier == null) {
    print("Ce n'est pas un nombre entier valide !");
  } else {
    print("Le nombre entier est : $entier");
  }
  print("Choisissez un mot de passe :");
  String? login1 = stdin.readLineSync();
  User user1 = User(username1, age1, login1);
  user1.login();
  print("Bienvenue $username1");
}

class User{
    User(String? username, String? age, String? login);

    void login (){
      print("login réusiss");
    }
}