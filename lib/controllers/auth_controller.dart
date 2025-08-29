import 'dart:convert';
import 'package:catalogue_3av/model/service_model.dart';
import 'package:catalogue_3av/widgets/navbar_roots.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../model/personnel.dart';
import '../model/user_model.dart';
import '../sreems/login_screen.dart';

class AuthentificationController extends GetxController {
  final box = GetStorage();
  final isLoading = false.obs;
  String token = '';
  var user = Rxn<User>();
  final RxList<PersonnelModel> listePersonnel = <PersonnelModel>[].obs;
  final RxList<Service> listeService = <Service>[].obs;
  var filterPersonnel = <PersonnelModel>[].obs;
  var query = ''.obs;
  @override
  void onInit() {
    super.onInit();
    filterPersonnel.value =
        listePersonnel; // Initialiser la liste filtrée avec tous les dossiers
  }

  //Fontion de recherche des dossiers
  void recherchePersonnel(String query) {
    if (query.isEmpty) {
      filterPersonnel.value = listePersonnel;
    } else {
      filterPersonnel.value =
          listePersonnel
              .where(
                (dossier) =>
                    dossier.prenom!.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    dossier.nom!.toString().contains(query.toLowerCase()),
              )
              .toList();
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await http.post(
      Uri.parse("${url}/change-password"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "current_password": currentPassword,
        "new_password": newPassword,
        "new_password_confirmation": confirmPassword,
      }),
    );

    final data = jsonDecode(response.body);

    return {"status": response.statusCode, "data": data};
  }
  // Fonction pour se connecter
  Future login({required String matricule, required String password}) async {
    try {
      isLoading.value = true;
      var data = {'matricule': matricule, 'password': password};
      var request = await http.post(
        Uri.parse('${url}/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // important pour JSON
        },
        body: jsonEncode(data), // on encode le Map en JSON string
      );

      // print('statusCode: ${request.statusCode}');
      // print('response body: ${request.body}');

      if (request.statusCode == 200) {
        var responseData = json.decode(request.body);

        // Corrigé : on va chercher dans la sous-clé
        token = responseData['access_token'];
        box.write('access_token', token);
        var userData = responseData['user'];
        // print(userData);
        user.value = User.fromJson(userData);
        Get.offAll(() => NavBarRoots());
      } else {
        Get.snackbar(
          "Connexion",
          "Échec, identifiants incorrects",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Erreur : $e");
      Get.snackbar(
        "Erreur",
        "Une erreur s'est produite",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fonction pour se déconnecter
  Future logout() async {
    try {
      await http.post(
        Uri.parse('${url}/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${box.read('access_token')}', // Utilisation correcte du token
        },
      );

      box.erase();
      Get.offAll(
        () => LoginScreen(key: const ValueKey('login'), onLoginTap: () {}),
      ); // Rediriger vers la page de connexion
    } catch (e) {
      print("Erreur de déconnexion : $e");
    }
  }

  /// Met à jour l'utilisateur en local et sur le backend
  Future<void> updateUserRemote({
    required String nom,
    required String prenom,
    required String email,
    required String matricule,
    required String telephone,
    required int fonction_id,
    required int emploi_id,
    required int role_id,
    required int grade_id,
  }) async {
    final currentUser = user.value;
    if (currentUser == null) {
      Get.snackbar("Erreur", "Utilisateur non connecté");
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('$url/personnel_update/${currentUser.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'telephone': telephone,
          'matricule': matricule,
          'fonction_id': fonction_id,
          'emploi_id': emploi_id,
          'role_id': role_id,
          'grade_id': grade_id,
        }),
      );

      if (response.statusCode == 200) {
        // Mettre à jour l'utilisateur local avec les nouvelles valeurs
        user.update((val) {
          if (val != null) {
            val.nom = nom;
            val.prenom = prenom;
            val.email = email;
            val.telephone = telephone;
            val.fonction_id = fonction_id;
            val.emploi_id = emploi_id;
            val.role_id = role_id;
            val.grade_id = grade_id;
          }
        });

        Get.snackbar(
          "Succès",
          "Profil mis à jour avec succès",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Erreur",
          "Échec de mise à jour : ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue : $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

Future<bool> getListePersonnel() async {
  isLoading.value = true;
  try {
    final response = await http.get(
      Uri.parse('$url/personnel_index'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      // Corriger Unicode
      body = body.replaceAllMapped(RegExp(r'\\u00([0-9a-fA-F]{2})'), (match) {
        final hex = match.group(1);
        if (hex != null) {
          final code = int.parse(hex, radix: 16);
          return String.fromCharCode(code);
        }
        return match.group(0) ?? '';
      });

      // Corriger JSON mal formé
      body = body
          .replaceAll('""', '":"') // fix pour telephone""xxx
          .replaceAll(r'\/', '/'); // fix slashs échappés

      final decoded = json.decode(body)['user'];

      if (decoded is List) {
        listePersonnel.value =
            decoded.map((e) => PersonnelModel.fromJson(e)).toList();
        return true;
      } else {
        debugPrint('Erreur: réponse non liste: $decoded');
      }
    } else {
      debugPrint(
          'Erreur API: status ${response.statusCode}, body: ${response.body}');
    }
  } catch (e, stacktrace) {
    debugPrint('Exception dans getListePersonnel: $e\n$stacktrace');
  } finally {
    isLoading.value = false;
  }
  return false;
}


  Future<bool> getListeService() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/liste_service'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          listeService.value = decoded.map((e) => Service.fromJson(e)).toList();
          return true;
        } else {
          debugPrint('Erreur: réponse non liste: $decoded');
        }
      } else {
        debugPrint(
          'Erreur API: status ${response.statusCode}, body: ${response.body}',
        );
      }
    } catch (e, stacktrace) {
      debugPrint('Exception dans actualite: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }
}
