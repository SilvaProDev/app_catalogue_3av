import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/constants.dart';
import '../controllers/auth_controller.dart';
import '../sreems/contact_user.dart';

class MembreService extends StatefulWidget {
  final int serviceId;
  final String service;
  const MembreService({
    super.key,
    required this.serviceId,
    required this.service,
  });

  @override
  State<MembreService> createState() => _MembreServiceState();
}

class _MembreServiceState extends State<MembreService> {
  final AuthentificationController _authentificationController = Get.put(
    AuthentificationController(),
  );
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Charger le personnel après le build initial pour éviter l'erreur setState() pendant build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authentificationController.getListePersonnel();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filtrer la liste selon serviceId et recherche
  List getFilteredPersonnel() {
    final searchTerm = _searchController.text.toLowerCase();
    return _authentificationController.listePersonnel.where((p) {
      final matchesService = p.serviceId == widget.serviceId;
      final matchesSearch =
          p.nom.toLowerCase().contains(searchTerm) ||
          p.prenom.toLowerCase().contains(searchTerm);
      return matchesService && matchesSearch;
    }).toList();
  }

  Future<void> _reloadPersonnel() async {
    await _authentificationController.getListePersonnel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // ou la couleur que tu souhaites
        elevation: 2,
        iconTheme: IconThemeData(
          color: Colors.white, // 👈 couleur du bouton retour
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
          ), // tu peux ajuster si nécessaire
          child: Text(
            "Service CF: ${widget.service}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // couleur du texte
            ),
          ),
        ),
        centerTitle: false, // false pour aligner à gauche
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher par nom ou prénom...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F6FA),
                ),
                onChanged: (_) {
                  setState(() {}); // Rafraîchit le filtre à chaque saisie
                },
              ),
            ),

            // Liste des utilisateurs
            Expanded(
              child: Obx(() {
                final liste = getFilteredPersonnel();

                if (_authentificationController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (liste.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "⚠️ Aucun membre n'est rattaché à ce service\nou un problème est survenu lors du chargement.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _reloadPersonnel,
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: liste.length,
                    itemBuilder: (context, index) {
                      final user = liste[index];
                      return _buildUserCard(user);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(user) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactUser(user: user)),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child:
                      user.image != null && user.image.isNotEmpty
                          ? Image.network(
                            '$imageUrl/${user.image}',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  'images/avatar1.jpg',
                                  fit: BoxFit.cover,
                                ),
                          )
                          : Image.asset(
                            'images/avatar1.jpg',
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              const SizedBox(height: 8),

              // Nom complet
              Text(
                "${user.nom} ${user.prenom}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),

              // Téléphone
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      user.telephone ?? 'Non défini',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
