import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:catalogue_3av/model/emploi.dart';
import 'package:catalogue_3av/model/fonction.dart';
import 'package:catalogue_3av/model/grade.dart';
import 'package:catalogue_3av/model/prestation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../model/Remboursement.dart';
import '../model/carousel_slider.dart';
import '../model/pret.dart';
import '../model/suivi_pret.dart';
import '../model/type_prestation.dart';
import 'auth_controller.dart';

class FinanceController extends GetxController {
  final AuthentificationController _authController = Get.find();
  final isLoading = false.obs;
  final RxList<Pret> listePret = <Pret>[].obs;
  final RxList<Prestation> listePrestation = <Prestation>[].obs;
  final RxList<TypePrestation> listeTypePrestation = <TypePrestation>[].obs;
  final RxList<CarouselSliderModel> detailActualite =
      <CarouselSliderModel>[].obs;
  final RxList<CarouselSliderModel> actualites = <CarouselSliderModel>[].obs;
  final RxList<Remboursement> remboursements = <Remboursement>[].obs;
  final RxList<Fonction> fonctions = <Fonction>[].obs;
  final RxList<Grade> grades = <Grade>[].obs;
  final RxList<Emploi> emplois = <Emploi>[].obs;
  final RxList<SuiviPret> suiviPrets = <SuiviPret>[].obs;

  Future<bool> enregistrerPret({
    required double montant,
    required int trimestre,
    required int montantTotal,
    required String modePaiement,
    required String contact,
  }) async {
    isLoading.value = true;
    final data = {
      'montant': montant,
      'trimestre': trimestre,
      'montant_total': montantTotal,
      'mode_paiement': modePaiement,
      'contact': contact,
    };
    try {
      final response = await http
          .post(
            Uri.parse('$url/pret_store'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${_authController.token}',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == true ||
            responseData['status'] == 'success') {
          await getListePret();
          _showSuccess(
            responseData['message'] ?? "Prêt enregistré avec succès",
          );
          return true;
        } else {
          _handleServerError(responseData);
        }
      } else {
        _handleErrorResponse(response);
      }
    } on TimeoutException {
      _showError("Timeout - Serveur non disponible");
    } catch (e) {
      _showError("Erreur inattendue: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> enregistrerPrestation({
    required int type_prestation_id,
    required String observation,
    required File fichier, // <-- on ajoute ce paramètre
  }) async {
    isLoading.value = true;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/demande_prestation_store'),
      );

      // Ajout des champs texte
      request.fields['type_prestation_id'] = type_prestation_id.toString();
      request.fields['observation'] = observation;

      // Ajout du header Authorization
      request.headers['Authorization'] = 'Bearer ${_authController.token}';
      request.headers['Accept'] = 'application/json';

      // Ajout du fichier
      request.files.add(
        await http.MultipartFile.fromPath(
          'fichier', // <-- le nom du champ attendu par le backend
          fichier.path,
        ),
      );

      // Envoi de la requête
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getListePrestation();
        return true; // ici on retourne true car succès
      } else {
        _handleErrorResponse(response);
      }
    } on TimeoutException {
      _showError("Timeout - Serveur non disponible");
    } catch (e) {
      _showError("Erreur inattendue: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }

    return false; // si on passe ici, c’est un échec
  }

  Future<bool> validerPaiement(int idPret) async {
    print(idPret);
    try {
      final response = await http.put(
        Uri.parse('$url/vise_adherent/${idPret}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );

      if (response.statusCode == 200) {
        getListePret();
        Get.snackbar(
          "Succès",
          "Paiement validé avec succes merci de contacter la trésorière",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          "Erreur",
          "Échec de paiement : ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Erreur: $e');
      return false;
    }
  }

  Future<bool> getListeSuiviPret() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/suivi_pret'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          suiviPrets.value = decoded.map((e) => SuiviPret.fromJson(e)).toList();
          return true;
        } else {
          suiviPrets.value = [];
          debugPrint('Erreur: réponse non liste: $decoded');
        }
      } else {
        debugPrint(
          'Erreur API: status ${response.statusCode}, body: ${response.body}',
        );
      }
    } catch (e, stacktrace) {
      debugPrint('Exception dans getListeRemboursement: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getListeRemboursement() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/listeRemboursement'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          remboursements.value =
              decoded.map((e) => Remboursement.fromJson(e)).toList();
          return true;
        } else {
          remboursements.value = [];
          debugPrint('Erreur: réponse non liste: $decoded');
        }
      } else {
        debugPrint(
          'Erreur API: status ${response.statusCode}, body: ${response.body}',
        );
      }
    } catch (e, stacktrace) {
      debugPrint('Exception dans getListeRemboursement: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getListeFonctions() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/fonction_index'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          fonctions.value = decoded.map((e) => Fonction.fromJson(e)).toList();
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
      debugPrint('Exception dans fonctions: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getListeGrades() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/grade_index'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          grades.value = decoded.map((e) => Grade.fromJson(e)).toList();
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
      debugPrint('Exception dans grades: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getListeEmplois() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/emploi_index'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          emplois.value = decoded.map((e) => Emploi.fromJson(e)).toList();
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
      debugPrint('Exception dans grades: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getListePret() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/pret_index'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body)["pret"];
        if (decoded is List) {
          listePret.value = decoded.map((e) => Pret.fromJson(e)).toList();
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
      debugPrint('Exception dans getListePret: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getListePrestation() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/demande_prestation_index'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          listePrestation.value =
              decoded.map((e) => Prestation.fromJson(e)).toList();
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
      debugPrint('Exception dans prestation: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getTypePrestation() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/type_prestation_index'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          listeTypePrestation.value =
              decoded.map((e) => TypePrestation.fromJson(e)).toList();
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
      debugPrint('Exception dans TypePrestation: $e\n$stacktrace');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> getListeActualite() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$url/liste_actualites'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          actualites.value =
              decoded.map((e) => CarouselSliderModel.fromJson(e)).toList();
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

  Future getDetailActualite(actualiteId) async {
    try {
      isLoading.value = true;
      var uri = Uri.parse('$url/detail_actualite/$actualiteId');
      // print(uri);
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_authController.token}',
        },
      );
      //Vérifie la reponse de la requete
      if (response.statusCode == 200) {
        final jsonData = (json.decode(response.body)) as List<dynamic>;
        detailActualite.value =
            jsonData.map((data) => CarouselSliderModel.fromJson(data)).toList();
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _handleServerError(Map<String, dynamic> data) {
    final message = data['message'] ?? data['error'] ?? 'Erreur serveur';
    _showError(message.toString());
  }

  void _handleErrorResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      _handleServerError(data);
    } catch (e) {
      _showError("Erreur ${response.statusCode}: ${response.body}");
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Erreur",
      message,
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      "Succès",
      message,
      colorText: Colors.white,
      backgroundColor: Colors.green,
    );
  }
}
