import 'package:intl/intl.dart';

class Fonction {
  int id;
  String libelle;
  String code;

  Fonction({
    required this.id,
    required this.libelle,
    required this.code,
  });

  factory Fonction.fromJson(Map<String, dynamic> json) {
    return Fonction(
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
