class Commentaire {
  final String textComment;
  final String idCoursProgramme;


  Commentaire({
    required this.textComment,
    required this.idCoursProgramme,
   
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      textComment: json['textComment'],
      idCoursProgramme: json['idCoursProgramme'],
     
    );
  }
}