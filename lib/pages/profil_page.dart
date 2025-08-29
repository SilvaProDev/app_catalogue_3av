import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/auth_controller.dart';

class MyProfileScreen extends StatelessWidget {
 // const MyProfileScreen({Key? key}) : super(key: key);
  static String routeName = 'MyProfileScreen';
final AuthentificationController _authentificationController =
      Get.put(AuthentificationController());
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
                     Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          '$imageUrl/${_authentificationController.user.value?.image}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Image.asset(
                                              'images/avatar1.jpg',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                     
                  //  CircleAvatar(
                  //             radius: isTablet ? 60 : 50,
                  //             backgroundImage:
                  //                 (_authentificationController.user.value?.image !=null 
                  //                 && _authentificationController.user.value!.image!.isNotEmpty)
                  //                 ? NetworkImage(
                  //                   '${imageUrl}/${_authentificationController.user.value!.image!}',)
                  //                         as ImageProvider
                  //                 : const AssetImage("images/doctor1.jpg"),
                  //           ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( _authentificationController
                                            .user.value?.nom ?? 'Non défini',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text( _authentificationController
                                            .user.value?.prenom ?? 'Non défini',
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
              title: 'Exercice budgétaire',
              value: '2025',
              isTablet: isTablet,
            ),
             ProfileDetailRow(
              title: 'Date d\'adhésion',
              value: '01/01/2025',
              isTablet: isTablet,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfileDetailRow(
              title: 'Fonction',
              value:  _authentificationController
                                            .user.value?.fonction ?? 'Non défini',
              isTablet: isTablet,
            ),
            ProfileDetailRow(
              title: 'Emploi',
              value:  _authentificationController
                                            .user.value?.emploi ?? 'Non défini',
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
          value:  _authentificationController
                                            .user.value?.email ?? 'Non défini',
          isTablet: isTablet,
        ),
        ProfileDetailColumn(
          title: 'Nom et Prenom',
          value: "${ _authentificationController.user.value?.nom as String } "" ${ _authentificationController
                                            .user.value?.prenom as String}",
          isTablet: isTablet,
        ),
        ProfileDetailColumn(
          title: 'Matricule',
          value: '247896U',
          isTablet: isTablet,
        ),
        ProfileDetailColumn(
          title: 'Numéro',
          value: _authentificationController
                                            .user.value?.telephone ?? 'Non défini',
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
              const SizedBox(height: 10),
              Text(value, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 10),
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
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
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
