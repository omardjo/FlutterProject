class ZoneDeDanger {
  final String? id; // Make id nullable since it's not required for POST
  final double latitudeDeZoneDanger;
  final double longitudeDeZoneDanger;
  final String idUser;

  // Existing constructor remains unchanged
  ZoneDeDanger(
      {required this.id,
      required this.latitudeDeZoneDanger,
      required this.longitudeDeZoneDanger,
      required this.idUser});

  // Constructor for POST request without an id
  ZoneDeDanger.forPost(
      {this.id, // id is optional and can be null
      required this.latitudeDeZoneDanger,
      required this.longitudeDeZoneDanger,
      required this.idUser});

  factory ZoneDeDanger.fromJson(Map<String, dynamic> json) {
    return ZoneDeDanger(
      id: json['_id'],
      latitudeDeZoneDanger: json['latitudeDeZoneDanger'],
      longitudeDeZoneDanger: json['longitudeDeZoneDanger'],
      idUser: json['idUser'],
    );
  }
}
