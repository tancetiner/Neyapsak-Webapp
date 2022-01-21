class Event {
  int? id;
  String name;
  String eventType;
  DateTime eventStartDate;
  DateTime eventEndDate;
  String description;
  String image;
  String organiser;
  String city;
  String location;
  List<String> tags;
  bool isSaved;
  bool isBought;
  int minPrice;
  int maxPrice;

  Event({
    this.id,
    required this.name,
    required this.eventType,
    required DateTime eventStartDate,
    required DateTime eventEndDate,
    this.image = '',
    this.organiser = '',
    this.city = "",
    this.location = '',
    this.tags = const [],
    this.description = '',
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.isSaved = false,
    this.isBought = false,
  })  : this.eventStartDate = eventStartDate,
        this.eventEndDate = eventEndDate;

  factory Event.fromJson(Map<String, dynamic> json) {
    bool mySaved = false;
    bool myBought = false;
    if (json['isSaved'] == null) {
      mySaved = false;
    } else {
      mySaved = json['isSaved'];
    }
    if (json['isBought'] == null) {
      myBought = false;
    } else {
      myBought = json['isBought'];
    }
    return Event(
      id: json['eventID'],
      description: json["description"],
      name: json['name'],
      eventType: json['type'],
      location: json['region'],
      city: json['city'],
      eventStartDate: DateTime.parse(json['date']),
      eventEndDate:
          DateTime.parse(json['date']).add(Duration(days: json['duration'])),
      isSaved: mySaved, //json['isSaved'] == "true",
      isBought: myBought, //json['isBought'] == "true",
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
    );
  }
}

/*
  factory Event.fromJson(Map<String, dynamic> json) {
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

    return Event(
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
  }
*/
