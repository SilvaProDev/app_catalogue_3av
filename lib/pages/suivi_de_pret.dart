import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class SuiviPretPage extends StatelessWidget {
  final int etapeActuelle; // Étape en cours : 0 à 4
 final AuthentificationController _authentificationController =
      Get.put(AuthentificationController());
   SuiviPretPage({super.key, required this.etapeActuelle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suivi de la demande de prêt',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => NavBarRoots()),
            // );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: VerticalLoanStepper(currentStep: etapeActuelle),
      ),
    );
  }
}

class VerticalLoanStepper extends StatelessWidget {
  
  final int currentStep;

  const VerticalLoanStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'Président', 'date': '15/06/2025', 'icon': Icons.gavel},
      // {'title': 'Trésorière', 'date': '01/07/2025', 'icon': Icons.verified_user},
      {'title': 'Kouassi', 'date': '01/07/2025', 'icon': Icons.person},
      {'title': 'Décaissement', 'date': '0', 'icon': Icons.attach_money},
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circle indicator
                Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          isCompleted
                              ? Colors.green
                              : isCurrent
                              ? Colors.orange
                              : Colors.grey.shade300,
                      child: Icon(
                        steps[index]['icon'] as IconData,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    if (index < steps.length - 1)
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.grey.shade300,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Step content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[index]['title'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isCompleted || isCurrent
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isCompleted
                            ? '✔ ${steps[index]['date']}'
                            : isCurrent
                            ? '⏳ En cours...'
                            : '⏺ En attente',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isCompleted
                                  ? Colors.green
                                  : isCurrent
                                  ? Colors.orange
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }
}
