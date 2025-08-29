import 'package:flutter/material.dart';
import '../widgets/cf_central.dart';
import '../widgets/diaspora.dart';
import '../controllers/auth_controller.dart';
import 'package:get/get.dart';

class ServiceScreem extends StatefulWidget {
  const ServiceScreem({super.key});

  @override
  State<ServiceScreem> createState() => _ServiceScreemState();
}

class _ServiceScreemState extends State<ServiceScreem> {
  int _buttonIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final AuthentificationController _authController = Get.put(AuthentificationController());

  @override
  void initState() {
    super.initState();
    _reloadData(); // Charge les données au démarrage
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fonction pour recharger les données depuis le backend
  Future<void> _reloadData() async {
    await _authController.getListeService();
    await _authController.getListePersonnel();
    setState(() {}); // Redessine la page après récupération
  }

  // Retourne le widget correspondant à l'onglet sélectionné
  Widget _getCurrentWidget() {
    switch (_buttonIndex) {
      case 0:
        return CfCentral(localite: 0, searchTerm: _searchController.text);
      case 1:
        return CfCentral(localite: 1, searchTerm: _searchController.text);
      case 2:
        return CfCentral(localite: 2, searchTerm: _searchController.text);
      case 3:
        return CfCentral(localite: 3, searchTerm: _searchController.text);
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Controleurs financiers et sous-directions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                  fillColor: Color(0xFFF4F6FA),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                ),
                onChanged: (value) {
                  setState(() {}); // Redessine le widget pour appliquer le filtre
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: _buildTabButton(0, "CF Central")),
                  Expanded(child: _buildTabButton(1, "CF local")),
                  Expanded(child: _buildTabButton(2, "Sous-Directions")),
                  Expanded(child: _buildTabButton(3, "Diaspora")),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _reloadData,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: _getCurrentWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          _buttonIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _buttonIndex == index ? Color(0xFF7165D6) : Colors.transparent,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _buttonIndex == index ? Colors.white : Colors.black38,
          ),
        ),
      ),
    );
  }
}
