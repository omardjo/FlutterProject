class Catastrophee {
  final String id;
  final String titre;
  final String type;
  final String description;
  final DateTime date;
  final double radius;
  final double magnitude;
  final double latitudeDeCatastrophe;
  final double longitudeDeCatastrophe;

  Catastrophee({
    required this.id,
    required this.titre,
    required this.type,
    required this.description,
    required this.date,
    required this.radius,
    required this.magnitude,
    required this.latitudeDeCatastrophe,
    required this.longitudeDeCatastrophe,
  });

  factory Catastrophee.fromJson(Map<String, dynamic> json) {
    return Catastrophee(
      id: json['_id'],
      titre: json['titre'],
      type: json['type'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      radius: json['radius'].toDouble(),
      magnitude: json['magnitude'].toDouble(),
      latitudeDeCatastrophe: json['latitudeDeCatastrophe'].toDouble(),
      longitudeDeCatastrophe: json['longitudeDeCatastrophe'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titre': titre,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
      'radius': radius,
      'magnitude': magnitude,
      'latitudeDeCatastrophe': latitudeDeCatastrophe,
      'longitudeDeCatastrophe': longitudeDeCatastrophe,
    };
  }
}