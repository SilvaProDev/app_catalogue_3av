class TypePrestation {
  final int id;
  final String code;
  final String libelle;

  TypePrestation({
    required this.id,
    required this.code,
    required this.libelle,
  });

  factory TypePrestation.fromJson(Map<String, dynamic> json) {
    return TypePrestation(
      id: json['id'] as int,
      code: json['code'] as String,
      libelle: json['libelle'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'libelle': libelle,
    };
  }

}
