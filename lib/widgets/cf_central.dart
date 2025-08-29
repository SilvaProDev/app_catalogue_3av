import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/auth_controller.dart';
import 'membre_service.dart';

class CfCentral extends StatefulWidget {
  final int localite;
  final String searchTerm;
  const CfCentral({super.key, required this.localite, this.searchTerm = ''});

  @override
  State<CfCentral> createState() => _CfCentralState();
}

class _CfCentralState extends State<CfCentral> {
  final AuthentificationController _authController = Get.put(
    AuthentificationController(),
  );

  @override
  void initState() {
    super.initState();
    // Charger les données depuis le backend
    _authController.getListeService();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        // Filtrer la liste par localite
        final filteredCFs =
            _authController.listeService
                .where(
                  (cf) =>
                      cf.localite == widget.localite &&
                      cf.libelle.toLowerCase().contains(
                        widget.searchTerm.toLowerCase(),
                      ),
                )
                .toList();

        if (_authController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (filteredCFs.isEmpty) {
          return Center(child: Text("Aucun contrôleur pour cette localité."));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            ...filteredCFs.map(
              (cf) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MembreService(
                              serviceId: cf.id,
                              service: cf.libelle,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse((cf.couleur).replaceFirst('#', '0xff')),
                      ), // Assure-toi que cf.color est un Color
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        title: Text(
                          cf.libelle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${cf.structureController}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            // Text(
                            //   "Cel: ${cf.id}",
                            //   style: const TextStyle(color: Colors.white),
                            // ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              (cf.image != null && cf.image != '')
                                  ? NetworkImage('$imageUrl/${cf.image}')
                                  : const AssetImage("images/avatar1.jpg")
                                      as ImageProvider,
                          onBackgroundImageError: (_, __) {
                            // Si erreur de chargement réseau, on peut afficher un Asset par défaut
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
