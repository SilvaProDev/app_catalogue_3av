import 'service_model.dart';

class User {
  final int id;
  final String nom;
  final String prenom;
  final String numero;
  final String fonction;
  final String emploi;
  final String grade;
  final String image;
  final Service service;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.numero,
    required this.fonction,
    required this.emploi,
    required this.grade,
    required this.image,
    required this.service,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      numero: map['numero'],
      fonction: map['fonction'],
      emploi: map['emploi'],
      grade: map['grade'],
      image: map['image'],
      service: Service.fromMap(map['service']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'numero': numero,
      'fonction': fonction,
      'emploi': emploi,
      'grade': grade,
      'image': image,
      'service': service.toMap(),
    };
  }
}
