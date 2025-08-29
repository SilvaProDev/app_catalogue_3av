import 'package:intl/intl.dart';

class Grade {
  int id;
  String libelle;
  String code;

  Grade({
    required this.id,
    required this.libelle,
    required this.code,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
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
