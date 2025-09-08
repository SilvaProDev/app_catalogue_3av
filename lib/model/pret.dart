import 'package:intl/intl.dart';

class Pret {
  final int id;
  final int montant;
  final int? position;
  final int trimestre;
  final String modePaiement;
  final int montantTotal;
  final int statut;
  final DateTime? dateEmprunt;

  Pret({
    required this.id,
    required this.montant,
     this.position,
    required this.trimestre,
    required this.modePaiement,
    required this.montantTotal,
    this.dateEmprunt,
    required this.statut,
  });

  factory Pret.fromJson(Map<String, dynamic> json) {
    return Pret(
      id: json['id'],
      montant: json['montant'],
      position: json['position'],
      trimestre: json['trimestre'],
      statut: json['statut'],
      modePaiement: json['mode_paiement'] ?? '',
      montantTotal: json['montant_total'],
      dateEmprunt: json['date_emprunt'] != null && json['date_emprunt'] != ''
          ? DateFormat('dd-MM-yyyy').parse(json['date_emprunt'])
          : null,
    );
  }
}
