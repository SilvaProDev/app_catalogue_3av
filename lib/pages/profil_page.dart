import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);
  static String routeName = 'MyProfileScreen';

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profile'),

      ),
      body: SingleChildScrollView(
        child: Container(
          color: kOtherColor,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: isTablet ? 190 : 150,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: kBottomBorderRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: isTablet ? 48 : 52,
                      backgroundColor: kSecondaryColor,
                      backgroundImage: const AssetImage('images/doctor1.jpg'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ouattara DAOUDA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Informaticien',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildProfileRows(context, isTablet),
              const SizedBox(height: 16),
              _buildProfileColumns(context, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRows(BuildContext context, bool isTablet) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfileDetailRow(
              title: 'Référence 3AV',
              value: '2025-OD-09-05',
              isTablet: isTablet,
            ),
            ProfileDetailRow(
              title: 'Exercice budgétaire',
              value: '2025',
              isTablet: isTablet,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfileDetailRow(
              title: 'Fonction',
              value: 'Informaticien',
              isTablet: isTablet,
            ),
            ProfileDetailRow(
              title: 'Emploi',
              value: 'Développeur',
              isTablet: isTablet,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfileDetailRow(
              title: 'Date d\'adhésion',
              value: '01/01/2025',
              isTablet: isTablet,
            ),
            ProfileDetailRow(
              title: 'Anniversaire',
              value: '09/10/2021',
              isTablet: isTablet,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileColumns(BuildContext context, bool isTablet) {
    return Column(
      children: [
        ProfileDetailColumn(
          title: 'Email',
          value: 'ouattara.daouda4613@gmail.com',
          isTablet: isTablet,
        ),
        ProfileDetailColumn(
          title: 'Nom et Prenom',
          value: 'Ouattara  Daouda',
          isTablet: isTablet,
        ),
        ProfileDetailColumn(
          title: 'Matricule',
          value: '247896U',
          isTablet: isTablet,
        ),
        ProfileDetailColumn(
          title: 'Numéro',
          value: '0546134701/0707164602',
          isTablet: isTablet,
        ),
      ],
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({
    Key? key,
    required this.title,
    required this.value,
    required this.isTablet,
  }) : super(key: key);

  final String title;
  final String value;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: kTextBlackColor,
                  fontSize: isTablet ? 14 : 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: const Divider(thickness: 1.0),
              ),
            ],
          ),
          Icon(Icons.lock_outline, size: isTablet ? 14 : 16),
        ],
      ),
    );
  }
}

class ProfileDetailColumn extends StatelessWidget {
  const ProfileDetailColumn({
    Key? key,
    required this.title,
    required this.value,
    required this.isTablet,
  }) : super(key: key);

  final String title;
  final String value;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: kTextBlackColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Divider(thickness: 1.0),
              ),
            ],
          ),
          Icon(Icons.lock_outline, size: 20),
        ],
      ),
    );
  }
}
