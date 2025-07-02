import 'package:catalogue_3av/main.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../widgets/navbar_roots.dart';

class OrgChartPage extends StatelessWidget {
  const OrgChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Graph graph = Graph()..isTree = true;
    final BuchheimWalkerConfiguration builder =
        BuchheimWalkerConfiguration()
          ..siblingSeparation = 1
          ..levelSeparation = 40
          ..subtreeSeparation = 3
          ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    // Création des nœuds avec données personnalisées
    final ceo = Node.Id('PRESIDENT');
    final cto = Node.Id('VICE');
    final cfo = Node.Id('CONSEILLER');
    final dev1 = Node.Id('SECRETAIRE');
    final adjoint = Node.Id('SECRETAIRE-ADJOINT');
    final dev2 = Node.Id('TRESORIERE');
    final adjointe = Node.Id('TRESORIERE-ADJOINTE');

    graph.addEdge(ceo, cto);
    graph.addEdge(ceo, cfo);
    graph.addEdge(cto, dev1);
    graph.addEdge(cto, dev2);
    graph.addEdge(dev1, adjoint);
    graph.addEdge(dev2, adjointe);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Organigramme Bureau des 3AV',),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavBarRoots()),
            );
          },
        ),
      ),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.01,
        maxScale: 4.0,
        child: GraphView(
          graph: graph,
          algorithm: BuchheimWalkerAlgorithm(
            builder,
            TreeEdgeRenderer(builder),
          ),
          builder: (Node node) {
            final nodeId = node.key!.value as String;
            return _buildCustomNode(nodeId);
          },
        ),
      ),
    );
  }
}

Widget _buildCustomNode(String id) {
  // Données simulées avec image réseau (ou asset)
  final Map<String, Map<String, String>> nodeData = {
    'PRESIDENT': {
      'name': 'Aboubacar S Berthe',
      'position': 'PRESIDENT',
      'email': 'Aboubacar@gmail.com',
      'phone': '0707164609',
      'image': 'doctor5.jpeg',
    },
    'VICE': {
      'name': 'GUILLAUME KOUA',
      'position': 'VICE PRESIDENT',
      'email': 'bob@example.com',
      'phone': '234-567-8901',
      'image': 'doctor5.jpeg',
    },
    'CONSEILLER': {
      'name': 'MEL MELESS DARIUS',
      'position': 'CONSEILLER SOCIALES',
      'email': 'meless@gmail.com',
      'phone': '0778596854',
      'image': 'doctor5.jpeg',
    },
    'SECRETAIRE': {
      'name': 'FULGENCE K KONAN',
      'position': 'SECRETAIRE GENERAL',
      'email': 'konan@gmail.com',
      'phone': '0141525487',
      'image': 'doctor5.jpeg',
    },
    'TRESORIERE': {
      'name': 'KOUAKOU E.A JUSKA',
      'position': 'TRESORIERE GENRALE',
      'email': 'juska@gmail.com',
      'phone': '0152636984',
      'image': 'doctor5.jpeg',
    },
    'SECRETAIRE-ADJOINT': {
      'name': 'KOUASSI E.S VINCENT',
      'position': 'SECRETAIRE GENERAL ADJOINT',
      'email': 'vincent@gmail.com',
      'phone': '0546134587',
      'image': 'doctor5.jpeg',
    },
    'TRESORIERE-ADJOINTE': {
      'name': 'GNEPA EPSE KOUAME',
      'position': 'TRESORIERE GENRALE ADJOINTE',
      'email': 'juska@gmail.com',
      'phone': '0506010204',
      'image': 'doctor5.jpeg',
    },
  };

  final data = nodeData[id]!;

  return GestureDetector(
    onTap: () {
      // Affiche une boîte de dialogue avec les détails
      showDialog(
        context: navigatorKey.currentContext!,
        builder:
            (context) => AlertDialog(
              title: Text(data['name']!),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("images/${data['image']!}"),
                  ),
                  const SizedBox(height: 10),
                  Text('Poste: ${data['position']}'),
                  Text('Email: ${data['email']}'),
                  Text('Téléphone: ${data['phone']}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fermer'),
                ),
              ],
            ),
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("images/${data['image']!}"),
              radius: 30,
            ),
            const SizedBox(height: 5),
            Text(
              data['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              data['position']!, 
              style: const TextStyle(color: Colors.grey)
              ),
          ],
        ),
      ),
    ),
  );
}
