import 'service_model.dart';

class User {
   int id;
    String nom;
    String prenom;
    String? telephone;
    String? email;
    String? fonction;
    String? emploi;
    String? matricule;
    String? grade;
    int? fonction_id;
    int? emploi_id;
    int role_id;
    int? grade_id;
    String? image;
   Service? service;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
   required this.role_id,
    this.telephone,
    this.fonction_id,
    this.fonction,
    this.emploi_id,
    this.matricule,
    this.emploi,
    this.grade_id,
    this.grade,
    this.email,
    this.image,
    this.service,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0, // Valeur par défaut si null
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      matricule: map['matricule'] ?? '',
      email: map['email'] ?? '',
      telephone: map['telephone'],
      fonction_id: map['fonction_id'],
      emploi_id: map['emploi_id'],
      grade_id: map['grade_id'],
      role_id: map['role_id'],
      image: map['image'],
      service: map['service'] != null ? Service.fromJson(map['service']) : null,
    );
  }

  Map<String, dynamic> toJson() { // Renommé de fromJson à toJson pour la convention
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'matricule': matricule,
      'email': email,
      'telephone': telephone,
      'fonction_id': fonction_id,
      'emploi_id': emploi_id,
      'grade_id': grade_id,
      'role_id': role_id,
      'image': image,
      'service': service?.toJson(), // Utilisation de l'opérateur null-aware
    };
  }
}