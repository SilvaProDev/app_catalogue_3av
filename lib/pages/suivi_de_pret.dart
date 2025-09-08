import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/finance_controller.dart';

class SuiviPretsPage extends StatefulWidget {
  const SuiviPretsPage({super.key});

  @override
  State<SuiviPretsPage> createState() => _SuiviPretsPageState();
}

class _SuiviPretsPageState extends State<SuiviPretsPage> {
  final FinanceController controller = Get.put(FinanceController());

  @override
  void initState() {
    super.initState();
    controller.getListeSuiviPret();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "En attente";
    return "${date.day}/${date.month}/${date.year}";
  }

  /// Retourne le statut basé sur les dates
  String getStepStatusByDate(
    DateTime? date,
    DateTime? prevDate,
    DateTime? nextDate,
  ) {
    if (date != null) return "validé";
    if (prevDate != null && nextDate != null) return "en cours";
    if (prevDate != null && nextDate == null) return "en cours";
    if (prevDate == null) return "en attente";
    return "en attente";
  }
final formatMontant = NumberFormat.currency(
    locale: 'fr_FR', // pour le format français
    symbol: 'FCFA', // ou '$', '€', etc.
    decimalDigits: 0, // pas de décimales
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suivi des prêts"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.suiviPrets.isEmpty) {
          return const Center(child: Text("Aucun prêt trouvé"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.suiviPrets.length,
          itemBuilder: (context, index) {
            final pret = controller.suiviPrets[index];
            final steps = [
              {"label": "Président", "date": pret.datePresident},
              {"label": "Trésorière", "date": pret.dateTresorie},
              {"label": "Adhérent", "date": pret.dateAdherent},
              {"label": "Paiement", "date": pret.datePaiement},
            ];

            // Trouver la première étape non remplie pour l'afficher "En cours"
            int firstNullIndex = steps.indexWhere((s) => s["date"] == null);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Text(
                    //   "Prêt #${pret.id}",
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 16,
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Statut:"),
                        SizedBox(width: 6),
                        Text(
                          "${pret.statutText}",
                          style: TextStyle(
                            color: pret.statutColor,
                            fontWeight: FontWeight.bold, // optionnel
                          ),
                        ),
                        SizedBox(width: 20),
                          Text("Montant:"),
                        SizedBox(width: 8),
                        Text(
                          formatMontant.format(pret.montant),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(steps.length, (i) {
                          final step = steps[i];
                          final date = step["date"] as DateTime?;

                          // Déterminer le statut
                          String status;
                          if (date != null) {
                            status = "validé";
                          } else if (i == firstNullIndex) {
                            status = "en cours";
                          } else {
                            status = "en attente";
                          }

                          Color color;
                          IconData icon;
                          switch (status) {
                            case "validé":
                              color = Colors.green;
                              icon = Icons.check;
                              break;
                            case "en cours":
                              color = Colors.orange;
                              icon = Icons.play_arrow;
                              break;
                            default:
                              color = Colors.grey.shade400;
                              icon = Icons.hourglass_empty;
                          }

                          return Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    if (i != 0)
                                      Expanded(
                                        child: Container(
                                          height: 3,
                                          color:
                                              steps[i - 1]["date"] != null
                                                  ? Colors.green
                                                  : Colors.grey.shade400,
                                        ),
                                      ),
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: color,
                                      child: Icon(icon, color: Colors.white),
                                    ),
                                    if (i != steps.length - 1)
                                      Expanded(
                                        child: Container(
                                          height: 3,
                                          color:
                                              date != null
                                                  ? Colors.green
                                                  : Colors.grey.shade400,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  step["label"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  status == "validé"
                                      ? _formatDate(date)
                                      : status == "en cours"
                                      ? "En cours"
                                      : "En attente",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: color,
                                    fontWeight:
                                        status == "en cours"
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
