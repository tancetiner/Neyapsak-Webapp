import 'ticket.dart';
import 'event.dart';

class RecipeCardType {
  static const card1 = 'card1';
  static const card2 = 'card2';
  static const card3 = 'card3';
}

class UserModel {
  String email;
  String userType;
  int city;
  List<Ticket> tickets;
  List<Event> likedEvents;

  UserModel({
    required this.email,
    required this.userType,
    this.city = 0,
    this.tickets = const [],
    this.likedEvents = const [],
  });

  /*factory UserModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredients>[];
    final instructions = <Instruction>[];

    if (json['ingredients'] != null) {
      json['ingredients'].forEach((v) {
        ingredients.add(Ingredients.fromJson(v));
      });
    }

    if (json['instructions'] != null) {
      json['instructions'].forEach((v) {
        instructions.add(Instruction.fromJson(v));
      });
    }

    return UserModel(
      id: json['id'] ?? '',
      cardType: json['cardType'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      backgroundImage: json['backgroundImage'] ?? '',
      backgroundImageSource: json['backgroundImageSource'] ?? '',
      message: json['message'] ?? '',
      authorName: json['authorName'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profileImage'] ?? '',
      durationInMinutes: json['durationInMinutes'] ?? 0,
      dietType: json['dietType'] ?? '',
      calories: json['calories'] ?? 0,
      tags: json['tags'].cast<String>() ?? [],
      description: json['description'] ?? '',
      source: json['source'] ?? '',
      ingredients: ingredients,
      instructions: instructions,
    );
  }*/
}
