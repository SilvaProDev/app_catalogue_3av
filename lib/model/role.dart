import 'package:intl/intl.dart';

class Role {
  int id;
  String libelle;
  String code;

  Role({
    required this.id,
    required this.libelle,
    required this.code,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
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
