class Service {
  final int id;
  final String libelle;
  final String couleur;

  Service({
    required this.id,
    required this.libelle,
    required this.couleur,
  });

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      libelle: map['libelle'],
      couleur: map['couleur'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'couleur': couleur,
    };
  }
}
