import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:catalogue_3av/constants/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constants/constants.dart';
import '../controllers/auth_controller.dart';
import '../controllers/finance_controller.dart';
import '../model/emploi.dart';
import '../model/fonction.dart';
import '../model/grade.dart';

class EditProfileScreen extends StatefulWidget {
  static String routeName = 'EditProfileScreen';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthentificationController _authController = Get.find();
  final FinanceController _financeController = Get.put(FinanceController());

  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController emailController;
  late TextEditingController telephoneController;
  late TextEditingController matriculeController;

  int? selectedFonctionId;
  int? selectedEmploiId;
  int? selectedRoleId;
  int? selectedGradeId;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _image;
  bool _isLoading = false;

  final List<Map<String, dynamic>> fonctions = [
    {'id': 1, 'label': 'Manager'},
    {'id': 2, 'label': 'Développeur'},
    {'id': 3, 'label': 'Designer'},
    {'id': 4, 'label': 'Comptable'},
  ];

  final List<Map<String, dynamic>> emplois = [
    {'id': 1, 'label': 'CDI'},
    {'id': 2, 'label': 'CDD'},
    {'id': 3, 'label': 'Freelance'},
    {'id': 4, 'label': 'Stagiaire'},
  ];

  final List<Map<String, dynamic>> roles = [
    {'id': 1, 'label': 'Administrateur'},
    {'id': 2, 'label': 'Utilisateur'},
    {'id': 3, 'label': 'Modérateur'},
  ];

  final List<Map<String, dynamic>> grades = [
    {'id': 1, 'label': 'Junior'},
    {'id': 2, 'label': 'Intermédiaire'},
    {'id': 3, 'label': 'Senior'},
  ];

  @override
  void initState() {
    super.initState();
    _financeController.getListeEmplois().then((_) {
      setState(() {}); // force rebuild quand la liste est dispo
    });
    _financeController.getListeFonctions().then((_) {
      setState(() {});
    });
    _financeController.getListeGrades().then((_) {
      setState(() {});
    });
    final user = _authController.user.value;
    nomController = TextEditingController(text: user?.nom ?? '');
    prenomController = TextEditingController(text: user?.prenom ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    telephoneController = TextEditingController(text: user?.telephone ?? '');
    matriculeController = TextEditingController(text: user?.matricule ?? '');
    selectedFonctionId = user?.fonction_id;
    selectedEmploiId = user?.emploi_id;
    selectedRoleId = user?.role_id;
    selectedGradeId = user?.grade_id;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _updateProfilePicture();
    }
  }

  Future<void> _updateProfilePicture() async {
    if (_imageFile == null) {
      Get.snackbar(
        "Erreur",
        "Aucune photo sélectionnée",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading =
          true; // si tu as un booléen _isLoading pour afficher un loader
    });

    try {
      var uri = Uri.parse('$url/update-photo'); // 🔧 adapte l’URL
      var request = http.MultipartRequest('POST', uri);
      print(request);
      // Ajouter le fichier
      request.files.add(
        await http.MultipartFile.fromPath('image', _imageFile!.path),
      );

      // ⚠️ Si besoin, ajouter le token d'authentification dans les headers
      request.headers['Authorization'] = 'Bearer ${_authController.token}';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // print(data['data']['image']);

        // Met à jour localement la photo
        var newImage = data['data']['image'];
        _authController.user.update((val) {
          val?.image = newImage;
        });
        // Si le backend renvoie la nouvelle URL, tu peux mettre à jour localement
        // _authController.user.value.image = data['photo_url'];

        Get.snackbar(
          "Succès",
          "Photo de profil mise à jour",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Si besoin, appelle setState ou _authController.refresh()
      } else {
        print('Erreur backend: ${response.body}');
        Get.snackbar(
          "Erreur",
          "Impossible de mettre à jour la photo",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _saveProfile() async {
    setLoading(true);
    try {
      await _authController.updateUserRemote(
        nom: nomController.text.trim(),
        prenom: prenomController.text.trim(),
        email: emailController.text.trim(),
        telephone: telephoneController.text.trim(),
        matricule: matriculeController.text.trim(),
        fonction_id: selectedFonctionId ?? 0,
        emploi_id: selectedEmploiId ?? 0,
        role_id: selectedRoleId ?? 0,
        grade_id: selectedGradeId ?? 0,
      );
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Modifier mon profil')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            Obx(() {
                              final user = _authController.user.value;
                              return CircleAvatar(
                                radius: isTablet ? 60 : 50,
                                backgroundImage:
                                    (user?.image != null &&
                                            user!.image!.isNotEmpty)
                                        ? NetworkImage(
                                              '${imageUrl}/${user.image!}',
                                            )
                                            as ImageProvider
                                        : const AssetImage(
                                          "images/doctor1.jpg",
                                        ),
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: isTablet ? 16 : 14,
                                backgroundColor: kPrimaryColor,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: isTablet ? 18 : 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildTextField(
                        'Nom',
                        nomController,
                        Icons.person,
                        isTablet,
                      ),
                      _buildTextField(
                        'Prénom',
                        prenomController,
                        Icons.person_outline,
                        isTablet,
                      ),
                      _buildTextField(
                        'Email',
                        emailController,
                        Icons.email,
                        isTablet,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        'Téléphone',
                        telephoneController,
                        Icons.phone,
                        isTablet,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildTextField(
                        'Matricule',
                        matriculeController,
                        CupertinoIcons.person_crop_rectangle,
                        isTablet,
                        keyboardType: TextInputType.phone,
                      ),
                      Obx(
                        () => _buildDropdown<Fonction>(
                          'Fonction',
                          selectedFonctionId,
                          _financeController.fonctions,
                          (f) => f.id,
                          (f) => f.libelle,
                          (value) => setState(() => selectedFonctionId = value),
                          Icons.work,
                          isTablet,
                        ),
                      ),

                      Obx(
                        () => _buildDropdown<Emploi>(
                          'Emploi',
                          selectedEmploiId,
                          _financeController.emplois, // <- RxList<Emploi>
                          (e) => e.id, // id
                          (e) => e.libelle, // libelle
                          (value) => setState(() => selectedEmploiId = value),
                          Icons.badge,
                          isTablet,
                        ),
                      ),
                      // Obx(
                      //   () => _buildDropdown<Grade>(
                      //     'Rôle',
                      //     selectedRoleId,
                      //     _financeController.grades,
                      //     (f) => f.id,
                      //     (f) => f.libelle,
                      //     (value) => setState(() => selectedRoleId = value),
                      //     Icons.work,
                      //     isTablet,
                      //   ),
                      // ),
                      Obx(
                        () => _buildDropdown<Grade>(
                          'Grade',
                          selectedGradeId,
                          _financeController.grades,
                          (f) => f.id,
                          (f) => f.libelle,
                          (value) => setState(() => selectedGradeId = value),
                          Icons.work,
                          isTablet,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _saveProfile,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Enregistrer',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: TextStyle(fontSize: isTablet ? 20 : 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isTablet, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: isTablet ? 26 : 22),
          labelText: label,
          labelStyle: TextStyle(fontSize: isTablet ? 18 : 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

Widget _buildDropdown<T>(
  String label,
  int? selectedId,
  List<T> items,
  int Function(T) getId, // fonction pour récupérer l'id
  String Function(T) getLabel, // fonction pour récupérer le libelle
  Function(int?) onChanged,
  IconData icon,
  bool isTablet,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: DropdownButtonFormField<int>(
      isExpanded: true, // ✅ évite les overflows horizontaux
      value: items.any((item) => getId(item) == selectedId) ? selectedId : null,
      items: items
          .map(
            (item) => DropdownMenuItem<int>(
              value: getId(item),
              child: Text(
                getLabel(item),
                overflow: TextOverflow.ellipsis, // ✅ coupe le texte
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: isTablet ? 26 : 22),
        labelText: label,
        labelStyle: TextStyle(fontSize: isTablet ? 18 : 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    ),
  );
}

}
