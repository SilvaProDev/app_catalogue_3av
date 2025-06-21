import 'package:flutter/material.dart';

import '../widgets/cf_central.dart';
import '../widgets/cf_local.dart';
import '../widgets/sous_direction.dart';

class ServiceScreem extends StatefulWidget {
  const ServiceScreem({super.key});

  @override
  State<ServiceScreem> createState() => _ServiceScreemState();
}

class _ServiceScreemState extends State<ServiceScreem> {
  int _buttonIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final _sheduleWidgets = [
    CfCentral(),
    CfLocal(),
    SousDirection(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,),
          child: Text(
            "Controleurs financiers et sous-directions",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFFF4F6FA),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            ),
            onChanged: (value) {
              // Implémentez ici la logique de recherche
            },
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Color(0xFFF4F6FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabButton(0, "CF Central"),
              _buildTabButton(1, "CF local"),
              _buildTabButton(2, "Sous-Directions"),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: _sheduleWidgets[_buttonIndex],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          _buttonIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _buttonIndex == index ? Color(0xFF7165D6) : Colors.transparent,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _buttonIndex == index ? Colors.white : Colors.black38,
          ),
        ),
      ),
    );
  }
}