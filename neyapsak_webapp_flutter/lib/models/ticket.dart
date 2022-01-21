class RecipeCardType {
  static const card1 = 'card1';
  static const card2 = 'card2';
  static const card3 = 'card3';
}

class Ticket {
  String id;
  String ticketType;
  int isBought;

  Ticket({
    required this.id,
    required this.ticketType,
    required this.isBought,
  });

  /*factory Ticket.fromJson(Map<String, dynamic> json) {
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

    return Ticket(
      id: json['id'] ?? '',
      ticketType: json['cardType'] ?? '',
      isBought: json['title'] ?? '',
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
  }
*/
}
