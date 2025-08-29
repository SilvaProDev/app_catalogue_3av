class Paiement {
  final int id;
  final double montant;
  final int trimestre;
  final int montantTotal;
  final String modePaiement;
  final String? contact;

  Paiement({
    required this.id,
    required this.montant,
    required this.trimestre,
    required this.montantTotal,
    required this.modePaiement,
     this.contact,
  });

  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      id: json['id'] as int? ?? 0,
      montant: (json['montant'] as num?)?.toDouble() ?? 0.0,
      trimestre: json['trimestre'] as int? ?? 1,
      montantTotal: json['montant_total'] as int? ?? 1,
      modePaiement: json['mode_paiement'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'trimestre': trimestre,
      'montant_total': montantTotal,
      'mode_paiement': modePaiement,
      'contact': contact,
    };
  }
}