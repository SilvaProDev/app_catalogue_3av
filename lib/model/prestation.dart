import 'package:intl/intl.dart';

class Prestation {
  int id;
  int? montant;
  String libelle;
  String statut;
  DateTime? datePrestation;
  String fichier;

  Prestation({
    required this.id,
    this.montant,
    required this.libelle,
    required this.statut,
    required this.fichier,
    this.datePrestation,
  });

  factory Prestation.fromJson(Map<String, dynamic> json) {
    return Prestation(
      id: json['id'] ?? 0,
      montant: json['montant'] ?? 0,
      libelle: json['libelle']?.toString() ?? '',
      statut: json['statut']?.toString() ?? '',
      fichier: json['fichier']?.toString() ?? '',
      datePrestation: json['date_prestation'] != null && json['date_prestation'] != ''
          ? DateFormat('dd-MM-yyyy').parse(json['date_prestation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'libelle': libelle,
      'statut': statut,
      'fichier': fichier,
      'date_prestation': datePrestation != null
          ? DateFormat('dd-MM-yyyy').format(datePrestation!)
          : null,
    };
  }
}
