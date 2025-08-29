class CarouselSliderModel {
  final int? id;
   String? fichier;
   String? title;
   String? description;

  CarouselSliderModel({
    this.id,
    this.fichier,
    this.title,
    this.description,
  });

  // Pour construire depuis du JSON
  factory CarouselSliderModel.fromJson(Map<String, dynamic> json) {
    return CarouselSliderModel(
      id: json['id'] as int?,
      fichier: json['fichier'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
    );
  }

  // Pour convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fichier': fichier,
      'title': title,
      'description': description,
    };
  }
}
