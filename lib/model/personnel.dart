import 'service_model.dart';

class PersonnelModel {
  int id;
  String nom;
  String prenom;
  String? email;
  String? telephone;
  String? couleur; // stockée en hex string ex: "#4CAF50"
  int fonctionId;
  int? emploiId;
  int? gradeId;
  String? matricule;
  String? image;
  int roleId;
  int? serviceId;
  String? libelleRole;
  String? fonction;
  String? emploi;
  String? grade;
  Service? service;

  PersonnelModel({
    required this.id,
    required this.nom,
    required this.prenom,
    this.email,
    this.telephone,
    this.couleur,
    this.matricule,
    required this.fonctionId,
    this.emploiId,
    this.gradeId,
    this.serviceId,
    this.image,
    required this.roleId,
    this.libelleRole,
    this.fonction,
    this.emploi,
    this.grade,
    this.service,
  });

  factory PersonnelModel.fromJson(Map<String, dynamic> json) {
    return PersonnelModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      matricule: json['matricule'],
      emploi: json['emploi'],
      grade: json['grade'],
      email: json['email'],
      telephone: json['telephone'],
      fonctionId: json['fonction_id'] ?? 0,
      emploiId: json['emploi_id'],
      gradeId: json['grade_id'],
      serviceId: json['service_id'],
      image: json['image'],
      roleId: json['role_id'] ?? 0,
      couleur: json['couleur'], // reste String?
      libelleRole: json['libelle_role'],
      fonction: json['fonction'], 
      service: json['service'] != null ? Service.fromJson(json['service']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'fonction_id': fonctionId,
      'emploi_id': emploiId,
      'matricule': matricule,
      'emploi': emploi,
      'grade': grade,
      'grade_id': gradeId,
      'couleur': couleur,
      'image': image,
      'role_id': roleId,
      'service_id': serviceId,
      'libelle_role': libelleRole,
      'fonction': fonction,
      'service': service?.toJson(),
    };
  }
}
