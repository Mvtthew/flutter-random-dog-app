import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Dog {
  final String message;
  final String success;

  Dog({this.message, this.success});

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      message: json['message'],
      success: json['success']
    );
  }
}

Future<Dog> getRandomDog() async {
  var response = await http.get('https://dog.ceo/api/breeds/image/random');

  if (response.statusCode == 200) {
    return Dog.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch DOG');
  }

}

Future<List<String>> loadFavoriteDogs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getStringList('favoriteDogs') != null) {
    return prefs.getStringList('favoriteDogs');
  } else {
    return [];
  }
}

void saveFavoriteDogs(List<String> favoriteDogs) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('favoriteDogs', favoriteDogs);
}