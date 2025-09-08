import 'package:flutter/material.dart';

class SuiviPret {
  final int id;
  final int statut;
  final int montant;
  final DateTime? datePresident;
  final DateTime? dateTresorie;
  final DateTime? dateAdherent;
  final DateTime? datePaiement;

  SuiviPret({
    required this.id,
    required this.statut,
    required this.montant,
    this.datePresident,
    this.dateTresorie,
    this.dateAdherent,
    this.datePaiement,
  });

  factory SuiviPret.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? date) {
      if (date == null || date.isEmpty) return null;
      final parts = date.split('-'); // dd-MM-yyyy
      if (parts.length != 3) return null;
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) return null;
      return DateTime(year, month, day);
    }

    return SuiviPret(
      id: json['id'] as int,
      statut: json['statut'] as int,
      montant: json['montant'] as int,
      datePresident: parseDate(json['date_president'] as String?),
      dateTresorie: parseDate(json['date_tresorie'] as String?),
      dateAdherent: parseDate(json['date_adherent'] as String?),
      datePaiement: parseDate(json['date_paiement'] as String?),
    );
  }

  /// Retourne le statut calculé en fonction des dates
  String getStepStatus(int stepIndex) {
    final steps = [datePresident, dateTresorie, dateAdherent, datePaiement];

    for (int i = 0; i < steps.length; i++) {
      if (steps[i] == null) {
        return i == stepIndex - 1 ? "en cours" : "en attente";
      }
    }
    return "validé"; // toutes les dates sont remplies
  }

  /// Récupère la date d’une étape
  DateTime? getStepDate(int stepIndex) {
    switch (stepIndex) {
      case 1:
        return datePresident;
      case 2:
        return dateTresorie;
      case 3:
        return dateAdherent;
      case 4:
        return datePaiement;
      default:
        return null;
    }
  }
    String get statutText {
    switch (statut) {
      case 1:
        return 'En cours';
      case 2:
        return 'Validé';
      case 3:
        return 'Refusé';
      default:
        return 'Inconnu';
    }
  }
   Color get statutColor {
    switch (statut) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
