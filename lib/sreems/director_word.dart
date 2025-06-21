import 'package:catalogue_3av/sreems/home_screem.dart';
import 'package:flutter/material.dart';

import '../widgets/navbar_roots.dart';

class DirectorWord extends StatelessWidget {
  const DirectorWord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              // Image optimisée
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                height: MediaQuery.of(context).size.height * 0.35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "images/silva.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const Text(
                "Le mot du président",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildParagraph(
                      "Les chefs de services, les chargés d'études, les Agents Vérificateurs et Assimilés\n"
                      "constituent un vivier indispensable dans la mission de la Direction\n"
                      "du contrôle Financier."
                    ),
                    
                    const SizedBox(height: 15),
                    
                    _buildRichText(
                      prefix: "Regroupés au sein de ",
                      highlighted: "« l'Amicale des Agents Vérificateurs et Assimilés (3AV) »",
                      suffix: ",\nces Agents traitent, sur l'ensemble du territoire national,\nles dossiers relatifs à l'exécution des dépenses de l'État.",
                    ),
                    
                    const SizedBox(height: 15),
                    
                    _buildRichText(
                      prefix: "Dans le soucis de créer plus de proximité et de faciliter ",
                      highlighted: "les intéractions entre ses membres, le Bureau de l'Amicale a décidé",
                      suffix: "de mettre à leur disposition cette application mobille intitulé",
                      secondHighlighted: " «REPERTOIRE TELEPHONIQUE MOBILE DES 3AV»",
                    ),
                    
                    const SizedBox(height: 15),
                    
                    _buildParagraph(
                      "Cette application mobile donne en temps réel les informations suivantes:"
                    ),
                    
                    const SizedBox(height: 15),
                    
                    _buildFeatureList(),
                  ],
                ),
              ),
              
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black45,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRichText({
    required String prefix,
    required String highlighted,
    required String suffix,
    String? secondHighlighted,
  }) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black45,
          fontStyle: FontStyle.italic,
        ),
        children: [
          TextSpan(text: prefix),
          TextSpan(
            text: highlighted,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ),
          TextSpan(text: suffix),
          if (secondHighlighted != null)
            TextSpan(
              text: secondHighlighted,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      "Le service et sa localisation",
      "La photo",
      "Le nom et prénom",
      "Le contact téléphonique",
      "La fonction",
    ];

    return Column(
      children: features.map((feature) => 
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const Icon(Icons.directions, color: Colors.redAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature,
                  style: const TextStyle(
                    fontSize: 18, // Réduit de 20 à 18 pour plus de cohérence
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
      ).toList(),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavBarRoots()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF2F08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Suivant",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}