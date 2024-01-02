
class CoursProgramme{
  final String? id;
  final String Type;
  final String description;
  final String image ;


 CoursProgramme({
    this.id,
    required this.Type,
    required this.description,
    required this.image,

  });

  factory CoursProgramme.fromJson(Map<String, dynamic> json) {
   

    return CoursProgramme(
      id: json['_id'],
      Type: json['Type'],
      description: json['description'],
      image: json['image'],

  
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'Type': Type,
      'description': description,
       'image': image,
    };
   }
}


 