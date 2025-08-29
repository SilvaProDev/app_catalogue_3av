import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/Remboursement.dart';
import 'loanRepayement.dart';

class GlobalSummary extends StatelessWidget {
  final List<Remboursement> remboursementList;
  const GlobalSummary({super.key, required this.remboursementList});

  @override
  Widget build(BuildContext context) {
    final totalLoans = remboursementList.first.montantTotal ?? 0;
    final totalRepaid = remboursementList.fold(0.0, 
      (sum, r) => sum + (r.montantRembourse ?? 0));
    final remaining = totalLoans - totalRepaid;

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatCard(
            title: 'Synthèse Globale',
            children: [
              _buildStatItem(
                'Total emprunts',
                '${NumberFormat('#,##0').format(remboursementList.first.cumulMontantTotal)} FCFA',
                Icons.credit_card,
                Colors.deepPurple,
              ),
              _buildStatItem(
                'Total remboursés',
                '${NumberFormat('#,##0').format(totalRepaid)} FCFA',
                Icons.payment,
                Colors.green,
              ),
              _buildStatItem(
                'Reste à payer',
                '${NumberFormat('#,##0').format(remaining)} FCFA',
                Icons.timer,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildStatCard({required String title, required List<Widget> children}) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey[200]!, width: 1),
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    ),
  );
}

Widget _buildStatItem(String label, String value, IconData icon, Color color) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(color: Colors.grey[600]))),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    ),
  );
}

Color _getMutualColor() => Colors.purple;
IconData _getMutualIcon() => Icons.credit_card;

final Map<String, List<Loan>> loansByMutual = {
  '3AV': [
    Loan(amount: 500000, date: DateTime(2025, 5, 10), paymentMethod: 'MTN'),
    Loan(amount: 200000, date: DateTime(2025, 3, 15), paymentMethod: 'MTN'),
  ],
};
final List<Repayment> repayments = [
  Repayment(
    mutual: '3AV',
    paymentMethod: 'MTN',
    amount: 150000,
    date: DateTime(2025, 9, 12),
  ),
];

class Repayment {
  final String mutual;
  final int amount;
  final String paymentMethod;
  final DateTime date;

  Repayment({
    required this.mutual,
    required this.paymentMethod,
    required this.amount,
    required this.date,
  });
}

class Loan {
  final int amount;
  final DateTime date;
  final String paymentMethod;
  final List<Repayment> repayments;

  Loan({
    required this.amount,
    required this.date,
    required this.paymentMethod,
    this.repayments = const [],
  });
}
