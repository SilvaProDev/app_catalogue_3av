import 'package:intl/intl.dart';

class Emploi {
  int id;
  String libelle;
  String code;

  Emploi({
    required this.id,
    required this.libelle,
    required this.code,
  });

  factory Emploi.fromJson(Map<String, dynamic> json) {
    return Emploi(
      id: json['id'] ?? 0,
      libelle: json['libelle']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
   
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'code': code,
  
    };
  }
}
