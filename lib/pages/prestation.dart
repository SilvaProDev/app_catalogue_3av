import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../constants/constants.dart';
import '../controllers/finance_controller.dart';
import '../model/prestation.dart';
import '../model/type_prestation.dart';

class PrestationsScreen extends StatefulWidget {
  const PrestationsScreen({Key? key}) : super(key: key);

  @override
  _PrestationsScreenState createState() => _PrestationsScreenState();
}

class _PrestationsScreenState extends State<PrestationsScreen> {
  final FinanceController _financeController = Get.put(FinanceController());

  bool _showForm = false;
  bool _isLoading = false; // loader pendant envoi formulaire
  bool _isPageLoading = true; // loader au chargement initial

  final _formKey = GlobalKey<FormState>();
  TypePrestation? _selectedType;
  final _descriptionController = TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isPageLoading = true);
    await Future.wait([
      _financeController.getListePrestation(),
      _financeController.getTypePrestation(),
    ]);
    setState(() => _isPageLoading = false);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  Future<void> _joindreFichier() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner le fichier',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFile == null) {
      Get.snackbar(
        "Erreur",
        "Veuillez joindre un fichier",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setLoading(true);
    try {
      await _financeController.enregistrerPrestation(
        type_prestation_id: _selectedType!.id,
        observation: _descriptionController.text.trim(),
        fichier: _selectedFile!,
      );

      setState(() {
        _showForm = false;
        _selectedFile = null;
        _selectedType = null;
        _descriptionController.clear();
      });

      Get.snackbar(
        "Succès",
        "Demande envoyée avec succès",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Une erreur est survenue lors de l'envoi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setLoading(false);
    }
  }

   // Fonction pour télécharger et ouvrir le fichier
Future<void> _downloadAndOpenFile(String relativePath) async {
  try {
    final fullUrl = '$imageUrl/$relativePath';
    print('Téléchargement depuis: $fullUrl');

    final dir = await getTemporaryDirectory();
    final fileName = relativePath.split('/').last;
    final filePath = '${dir.path}/$fileName';
    print('Chemin local du fichier: $filePath');

    final file = File(filePath);

    if (!await file.exists()) {
      print('Fichier non trouvé localement, téléchargement...');
      final response = await http.get(Uri.parse(fullUrl));
      print('Status code du téléchargement: ${response.statusCode}');

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        print('Fichier téléchargé et sauvegardé. Taille: ${response.bodyBytes.length} octets');
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } else {
      print('Fichier déjà présent localement.');
    }

    if (file.path.endsWith('.jpg') || file.path.endsWith('.jpeg') || file.path.endsWith('.png')) {
      // Ouvrir dans une page Flutter
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Aperçu image')),
            body: Center(child: Image.file(file)),
          ),
        ),
      );
    } else {
      final result = await OpenFile.open(file.path);
      print('Résultat OpenFile: ${result.type}');
      if (result.type != ResultType.done) {
        Get.snackbar(
          "Erreur",
          "Impossible d'ouvrir le fichier",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

  } catch (e) {
    print('Erreur lors de l\'ouverture du fichier: $e');
    Get.snackbar(
      "Erreur",
      "Une erreur est survenue lors de l'ouverture du fichier",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Prestations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () => setState(() => _showForm = true),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
     body: Stack(
  children: [
    if (_isPageLoading)
      const Center(child: CircularProgressIndicator())
    else
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _financeController.listePrestation.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 230),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.event_busy, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Aucune prestation disponible",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: _financeController.listePrestation
                    .map((prestation) => _buildPrestationCard(prestation))
                    .toList(),
              ),
      ),
    if (_showForm) _buildFormModal(),
    if (_isLoading)
      Container(
        color: Colors.black38,
        child: const Center(child: CircularProgressIndicator()),
      ),
  ],
),
    );
  }

  Widget _buildPrestationCard(Prestation prestation) {
    Color statusColor;
    switch (prestation.statut) {
      case '2':
        statusColor = Colors.green;
        break;
      case '1':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prestation.libelle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    prestation.statut == '1'
                        ? 'Encours'
                        : prestation.statut == '2'
                        ? 'Approuvé'
                        : 'Réjeter',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${prestation.montant}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${prestation.datePrestation != null ? DateFormat('dd/MM/yyyy').format(prestation.datePrestation!) : 'Non précisée'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            // Fichier PDF s'il existe
            if (prestation.fichier != null &&
                prestation.fichier!.isNotEmpty) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _downloadAndOpenFile(prestation.fichier!),
                child: Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'fichier',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormModal() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Nouvelle demande',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<TypePrestation>(
                    value: _selectedType,
                    items:
                        _financeController.listeTypePrestation
                            .map(
                              (type) => DropdownMenuItem<TypePrestation>(
                                value: type,
                                child: Text(type.libelle),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => _selectedType = value),
                    decoration: InputDecoration(
                      labelText: 'Type de prestation',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator:
                        (value) =>
                            value == null
                                ? 'Veuillez sélectionner un type'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    maxLines: 3,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Veuillez entrer une description'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _joindreFichier,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.attach_file),
                        const SizedBox(width: 8),
                        Text(
                          _selectedFile != null
                              ? 'Fichier sélectionné'
                              : 'Joindre un fichier PDF ou image',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => setState(() {
                                _showForm = false;
                                _selectedFile = null;
                                _selectedType = null;
                                _descriptionController.clear();
                              }),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.deepPurple),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Annuler',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Envoyer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
