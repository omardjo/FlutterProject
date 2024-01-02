class Catastrophe {
  final String id;
  final String titre;
  final String type;
  final String description;
  final String date;
  final double radius;
  final double magnitude;
  final double latitudeDeCatastrophe;
  final double longitudeDeCatastrophe;

  Catastrophe({
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

  factory Catastrophe.fromJson(Map<String, dynamic> json) {
    return Catastrophe(
      id: json['_id'],
      titre: json['titre'],
      type: json['type'],
      description: json['description'],
      date: json['date'],
      radius: json['radius'],
      magnitude: json['magnitude'],
      latitudeDeCatastrophe: json['latitudeDeCatastrophe'],
      longitudeDeCatastrophe: json['longitudeDeCatastrophe'],
    );
  }
}
