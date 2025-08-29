import 'package:catalogue_3av/model/Remboursement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanRepaymentScreen extends StatelessWidget {
  final List<Remboursement> remboursementList;
  LoanRepaymentScreen({super.key, required this.remboursementList});
  final NumberFormat currencyFormat = NumberFormat("#,##0", "fr_FR");

  @override
  Widget build(BuildContext context) {
    // Calcul du total remboursé et restant
    final totalRepaid = remboursementList.fold(0.0, 
      (sum, r) => sum + (r.montantRembourse ?? 0));
    final remaining = (remboursementList.first.montantTotal ?? 0) - totalRepaid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du remboursement", 
        style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
        backgroundColor: Colors.purple,
         automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Résumé ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildSummaryRow("Montant total", 
                  remboursementList.first.cumulMontantTotal ?? 0, Colors.purple),
                const Divider(),
                _buildSummaryRow("Remboursé", totalRepaid, Colors.green),
                const Divider(),
                _buildSummaryRow("Restant", remaining, Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- Liste des remboursements ---
          Text(
            "Historique des remboursements",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (remboursementList.isEmpty)
            const Text("Aucun remboursement effectué pour le moment."),
          ...remboursementList.map((r) => _buildRepaymentCard(r)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.grey[800],
            )),
        Text(
          "${currencyFormat.format(amount)} FCFA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRepaymentCard(Remboursement r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.2),
          child: const Icon(Icons.attach_money, color: Colors.green),
        ),
        title: Text(
          "${currencyFormat.format(r.montantRembourse)} FCFA",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Remboursé le ${DateFormat('dd/MM/yyyy').format(r.dateRemboursement!)}",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}