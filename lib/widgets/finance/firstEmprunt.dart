import 'package:catalogue_3av/constants/constants.dart';
import 'package:catalogue_3av/model/pret.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/finance_controller.dart';

class FirstEmprunt extends StatelessWidget {
  final List<Pret> pretList;

  FirstEmprunt({super.key, required this.pretList});
  final FinanceController _financeController = Get.put(FinanceController());

  Color _getMutualColor() => Colors.purple;
  IconData _getMutualIcon() => Icons.credit_card;

void _onValiderPaiement(int pretId) async {
     await _financeController.validerPaiement(pretId);
  }

  @override
  Widget build(BuildContext context) {
    // Calcul du montant total de tous les prêts
final totalAmount = pretList.where((pret) => pret.statut == 2)
    .fold<int>(0, (sum, pret) => sum + pret.montant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ En-tête unique
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _getMutualColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(_getMutualIcon(), color: _getMutualColor()),
              SizedBox(width: 10),
              Text(
                '3AV',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _getMutualColor(),
                ),
              ),
              Spacer(),
              Text(
                '${NumberFormat('#,##0').format(totalAmount)} FCFA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),

        // ✅ Liste des prêts sans répéter le header
        ...pretList.map((pret) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
        child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getMutualColor().withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.money,
                        color: _getMutualColor(),
                        size: 20,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${NumberFormat('#,##0').format(pret.montant)} FCFA',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Mode: ${pret.modePaiement}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Emprunté le ${DateFormat('dd/MM/yyyy').format(pret.dateEmprunt!)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        pret.statut == 1
                            ? Icon(Icons.hourglass_top, color: Colors.orange)
                            : pret.statut == 2
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.cancel, color: Colors.red),
                        SizedBox(height: 5),
                        pret.statut == 1
                            ? Text("Encours..")
                            : pret.statut == 2
                            ? Text("Accepté")
                            : Text("Refusé"),
                      ],
                    ),
                  ),
                  // Bouton Valider en dessous du ListTile
                  //  if (pret.position == 3)
                  //   Padding(
                  //     padding: const EdgeInsets.only(
                  //       left: 50,
                  //       right: 16,
                  //       bottom: 8,
                  //     ),
                  //     child: ElevatedButton(
                  //       onPressed: () => _onValiderPaiement(pret.id),
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.deepPurple,
                  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  //       ),
                  //       child: Text(
                  //         "Valider mon paiement",
                  //         style: TextStyle(fontSize: 14, color: Colors.white),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),

        )),

        SizedBox(height: 20),
      ],
    );
  }
}
