import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/finance_controller.dart';
import '../model/suivi_pret.dart';

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
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return "$d/$m/$y";
  }

  final formatMontant = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'FCFA',
    decimalDigits: 0,
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
            final SuiviPret pret = controller.suiviPrets[index];

            // On garde ici 3 étapes (Président, Trésorière, Paiement) comme dans ton UI
            final List<String> labels = ['Président', 'Trésorière', 'Paiement'];
            final List<DateTime?> dates = [
              pret.datePresident,
              pret.dateTresorie,
              pret.datePaiement,
            ];

            // index de la première étape non remplie (ou -1 si toutes remplies)
            int firstNullIndex = dates.indexWhere((d) => d == null);
            if (firstNullIndex == -1) firstNullIndex = dates.length;

            final bool isRefused = pret.statut == 3;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ligne statut + montant, et badge REFUSÉ si besoin
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Statut:"),
                            const SizedBox(width: 6),
                            Text(
                              pret.statutText,
                              style: TextStyle(
                                color: pret.statutColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text("Montant:"),
                            const SizedBox(width: 8),
                            Text(
                              formatMontant.format(pret.montant),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if (isRefused)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: const Text(
                              "REFUSÉ",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Timeline des étapes
                    SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(labels.length, (i) {
                          final date = dates[i];

                          // Statut calculé selon la règle :
                          // - Si refusé globalement: président -> "refusé", les autres -> "en attente"
                          // - Sinon: date != null -> validé, sinon premier null -> en cours, sinon en attente
                          String status;
                          if (isRefused) {
                            if (i == 0) {
                              status = "refusé";
                            } else {
                              status = "en attente";
                            }
                          } else {
                            if (date != null) {
                              status = "validé";
                            } else if (i == firstNullIndex) {
                              status = "en cours";
                            } else {
                              status = "en attente";
                            }
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
                            case "refusé":
                              color = Colors.red;
                              icon = Icons.close;
                              break;
                            default:
                              color = Colors.grey.shade400;
                              icon = Icons.hourglass_empty;
                          }

                          // Couleur des connectors : verts seulement si pas de refus global ET la partie appropriée est validée
                          Color leftConnectorColor = Colors.transparent;
                          if (i != 0) {
                            final bool prevValidated =
                                dates[i - 1] != null && !isRefused;
                            leftConnectorColor =
                                prevValidated
                                    ? Colors.green
                                    : Colors.grey.shade400;
                          }

                          Color rightConnectorColor = Colors.transparent;
                          if (i != labels.length - 1) {
                            final bool thisValidated =
                                dates[i] != null && !isRefused;
                            rightConnectorColor =
                                thisValidated
                                    ? Colors.green
                                    : Colors.grey.shade400;
                          }

                          return Expanded(
                            child: Column(
                              children: [
                                // ligne + cercle
                                Row(
                                  children: [
                                    if (i != 0)
                                      Expanded(
                                        child: Container(
                                          height: 3,
                                          color: leftConnectorColor,
                                        ),
                                      ),
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: color,
                                      child: Icon(icon, color: Colors.white),
                                    ),
                                    if (i != labels.length - 1)
                                      Expanded(
                                        child: Container(
                                          height: 3,
                                          color: rightConnectorColor,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  labels[i],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Date / statut text
                                Text(
                                  status == "validé"
                                      ? _formatDate(date)
                                      : status == "refusé"
                                      ? _formatDate(date) // date du refus
                                      : status == "en cours"
                                      ? "En cours"
                                      : "En attente",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        status == "refusé"
                                            ? Colors.red
                                            : (status == "en cours"
                                                ? Colors.orange
                                                : color),
                                    fontWeight:
                                        status == "en cours"
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
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
