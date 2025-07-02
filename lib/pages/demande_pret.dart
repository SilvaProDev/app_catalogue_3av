import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanRequest {
  final String nom;
  final String prenom;
  final String matricule;
  final DateTime date;
  final int montant;
  final int trimestres;
  final String imageAsset;
  String statut;

  LoanRequest({
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.date,
    required this.montant,
    required this.trimestres,
    required this.imageAsset,
    this.statut = 'encours',
  });

  int get montantAvecInteret => (montant * 1.07).round();
}

class LoanListPage extends StatefulWidget {
  @override
  _LoanListPageState createState() => _LoanListPageState();
}

class _LoanListPageState extends State<LoanListPage> {
  List<LoanRequest> allLoans = [
    LoanRequest(
      nom: 'Kouassi',
      prenom: 'Jean',
      matricule: '1234',
      date: DateTime.now(),
      montant: 100000,
      trimestres: 2,
      imageAsset: 'images/doctor1.jpg',
    ),
    LoanRequest(
      nom: 'Traoré',
      prenom: 'Awa',
      matricule: '5678',
      date: DateTime.now(),
      montant: 200000,
      trimestres: 3,
      imageAsset: 'images/doctor2.jpg',
    ),
    LoanRequest(
      nom: 'Ouattara',
      prenom: 'Daouda',
      matricule: '9012',
      date: DateTime.now(),
      montant: 150000,
      trimestres: 1,
      imageAsset: 'images/doctor3.jpg',
    ),
  ];

  String searchQuery = '';

  void updateStatus(LoanRequest loan, String newStatus) {
    setState(() {
      loan.statut = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredLoans = allLoans.where((loan) {
      final fullName = '${loan.nom} ${loan.prenom}'.toLowerCase();
      return fullName.contains(searchQuery.toLowerCase()) ||
          loan.matricule.contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Etat de demandes de prêt"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher par nom ou matricule',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredLoans.length,
                itemBuilder: (context, index) {
                  final loan = filteredLoans[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(loan.imageAsset),
                        radius: 25,
                      ),
                      onTap: () => _showStatusDialog(context, loan),
                      title: Text('${loan.nom} ${loan.prenom}', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Matricule : ${loan.matricule}'),
                          Text('Date : ${DateFormat('dd/MM/yyyy').format(loan.date)}'),
                          Text('Montant : ${NumberFormat('#,##0').format(loan.montant)}'),
                          Text('Avec 7% : ${NumberFormat('#,##0').format(loan.montantAvecInteret)}'),
                          Text('Trimestres : ${loan.trimestres}'),
                        ],
                      ),
                      trailing: Chip(
                        label: Text(
                          loan.statut,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _statusColor(loan.statut),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context, LoanRequest loan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Décision du prêt"),
        content: Text("Choisissez le statut pour le prêt de ${loan.prenom} ${loan.nom}."),
        actions: [
          TextButton(
            onPressed: () {
              updateStatus(loan, 'accepté');
              Navigator.pop(context);
            },
            child: Text("Accepter"),
          ),
          TextButton(
            onPressed: () {
              updateStatus(loan, 'rejeté');
              Navigator.pop(context);
            },
            child: Text("Rejeter"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepté':
        return Colors.green;
      case 'rejeté':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
