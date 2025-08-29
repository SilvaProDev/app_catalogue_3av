class Remboursement {
  final int? pretId;
  final double? montantTotal;
  final double? montantRembourse;
  final double? montantRestant;
  final double? cumulMontantTotal;
  final DateTime? dateRemboursement;

  Remboursement({
    this.pretId,
    this.montantTotal,
    this.montantRembourse,
    this.montantRestant,
    this.cumulMontantTotal,
    this.dateRemboursement,
  });

  /// Création depuis JSON
  factory Remboursement.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v.replaceAll(',', '.'));
      return null;
    }

    return Remboursement(
      pretId: json['pret_id'] as int?,
      cumulMontantTotal: parseDouble(json['cumul_montant_total']),
      montantTotal: parseDouble(json['montant_total']),
      montantRembourse: parseDouble(json['montant_rembourse']),
      montantRestant: parseDouble(json['montant_restant']),
      dateRemboursement: json['date_remboursement'] != null
          ? DateTime.tryParse(json['date_remboursement'])
          : null,
    );
  }

  /// Conversion en JSON
  Map<String, dynamic> toJson() {
    return {
      'pret_id': pretId,
      'montant_total': montantTotal,
      'montant_rembourse': montantRembourse,
      'cumul_montant_total': cumulMontantTotal,
      'montant_restant': montantRestant,
      'date_remboursement': dateRemboursement?.toIso8601String(),
    };
  }

  /// Copie avec modifications
  Remboursement copyWith({
    int? pretId,
    double? montantTotal,
    double? montantRembourse,
    double? montantRestant,
    DateTime? dateRemboursement,
  }) {
    return Remboursement(
      pretId: pretId ?? this.pretId,
      montantTotal: montantTotal ?? this.montantTotal,
      montantRembourse: montantRembourse ?? this.montantRembourse,
      montantRestant: montantRestant ?? this.montantRestant,
      dateRemboursement: dateRemboursement ?? this.dateRemboursement,
    );
  }

  @override
  String toString() {
    return 'Remboursement(pretId: $pretId, montantTotal: $montantTotal, montantRembourse: $montantRembourse, montantRestant: $montantRestant, dateRemboursement: $dateRemboursement)';
  }
}
