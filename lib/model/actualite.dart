class DetailActualite {
   int id;
   String title;
   String description;

  DetailActualite({
    required this.id,
    required this.title,
    required this.description,
  });

  // Factory pour créer depuis un JSON
  factory DetailActualite.fromJson(Map<String, dynamic> json) {
    return DetailActualite(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  // Méthode pour convertir en JSON (utile si tu veux renvoyer le modèle)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
