import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  // Données statiques (à remplacer par ton API/local storage)
  final Stats stats = Stats(
    totalControllers: 62,
    totalChefs: 90,
    totalChargesEtude: 150,
    totalAgentsVerificateurs: 200,
    totalPersonnel: 402,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tableau de Bord',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Cartes Résumé (Grille)
              GridView.count(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // Désactive le scroll interne
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                children: [
                  _buildSummaryCard(
                    "Contrôleurs Financiers",
                    stats.totalControllers,
                    Colors.blue,
                  ),
                  _buildSummaryCard(
                    "Chefs de Service",
                    stats.totalChefs,
                    Colors.green,
                  ),
                  _buildSummaryCard(
                    "Chargés d'Étude",
                    stats.totalChargesEtude,
                    Colors.orange,
                  ),
                  _buildSummaryCard(
                    "Agents Vérificateurs",
                    stats.totalAgentsVerificateurs,
                    Colors.red,
                  ),
                  _buildSummaryCard(
                    "Total Personnel",
                    stats.totalPersonnel,
                    Colors.purple,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Graphique
              Container(height: 300, child: _buildStatsChart(stats)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int value, Color color) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8), // Ajoute une marge externe
      child: ConstrainedBox(
        // Contraint la hauteur minimale
        constraints: BoxConstraints(
          minHeight: 120, // Ajustez cette valeur selon vos besoins
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            // Padding plus serré
            vertical: 12,
            horizontal: 16,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Prend seulement l'espace nécessaire
            mainAxisAlignment: MainAxisAlignment.center, // Centre le contenu
            children: [
              Flexible(
                // Permet au texte de s'adapter
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14, // Taille réduite
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Limite à 2 lignes
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 22, // Taille légèrement réduite
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Graphique
  Widget _buildStatsChart(Stats stats) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: stats.totalControllers.toDouble(),
                color: Colors.blue,
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: stats.totalChefs.toDouble(),
                color: Colors.green,
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: stats.totalChargesEtude.toDouble(),
                color: Colors.orange,
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: stats.totalAgentsVerificateurs.toDouble(),
                color: Colors.red,
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Contrôleurs', style: TextStyle(fontSize: 10));
                  case 1:
                    return Text('Chefs', style: TextStyle(fontSize: 10));
                  case 2:
                    return Text('Chargés', style: TextStyle(fontSize: 10));
                  case 3:
                    return Text('Agents', style: TextStyle(fontSize: 10));
                  default:
                    return Text('');
                }
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false), // Désactive la grille
      ),
    );
  }
}

// Modèle de données (dans le même fichier pour simplicité)
class Stats {
  final int totalControllers;
  final int totalChefs;
  final int totalChargesEtude;
  final int totalAgentsVerificateurs;
  final int totalPersonnel;

  Stats({
    required this.totalControllers,
    required this.totalChefs,
    required this.totalChargesEtude,
    required this.totalAgentsVerificateurs,
    required this.totalPersonnel,
  });
}
