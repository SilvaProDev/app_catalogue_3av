class Service {
  final int id;
  final String libelle;
  final String couleur;
  final int localite;
  final String? structureController;
  final String? image;

  Service({
    required this.id,
    required this.libelle,
    required this.couleur,
    required this.localite,
     this.image,
     this.structureController,
  });

  /// Utilisée pour parser depuis une réponse JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      libelle: json['libelle']?.toString() ?? '',
      structureController: json['structure_controlle']?.toString() ?? '',
      couleur: json['couleur']?.toString() ?? '',
      localite: json['localite'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  /// Pour convertir en Map (ex: sauvegarde locale ou envoi à l'API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'structure_controlle': structureController,
      'couleur': couleur,
      'localite': localite,
      'image': image,
    };
  }
}
