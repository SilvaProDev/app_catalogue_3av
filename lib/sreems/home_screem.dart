import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/constants.dart';
import '../controllers/auth_controller.dart';
import 'contact_user.dart';

class HomeScreem extends StatefulWidget {
  HomeScreem({super.key});

  @override
  State<HomeScreem> createState() => _HomeScreemState();
}

class _HomeScreemState extends State<HomeScreem> {
  final AuthentificationController _authentificationController = Get.put(
    AuthentificationController(),
  );
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    // _authentificationController.getListePersonnel();
    _authentificationController.getListePersonnel().then((_) {
      setState(() {});
    });
    // _authentificationController.getListeService();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;
        double nextScroll = currentScroll + 80; // largeur approx. d’un item

        if (nextScroll >= maxScroll) {
          // Revenir au début quand on arrive à la fin
          _scrollController.animateTo(
            0,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            nextScroll,
            duration: Duration(seconds: 3),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec nom et photo de profil (fixe)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Obx(() {
                final user = _authentificationController.user.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user?.nom ?? '',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          (user!.image != null && user.image != 'default.png')
                              ? NetworkImage('$imageUrl/${user.image}')
                                  as ImageProvider
                              : const AssetImage("images/avatar1.jpg"),
                    ),
                  ],
                );
              }),
            ),

            // Search box (fixe)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 300,
                      child: TextFormField(
                        onChanged: (value) {
                          _authentificationController.query.value = value;
                          _authentificationController.recherchePersonnel(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Recherche",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Color(0xFF7165D6)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Le reste défilable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Liste "En ligne"
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "En ligne",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      final liste = _authentificationController.filterPersonnel;
                      return SizedBox(
                        height: 90,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: liste.length,
                          itemBuilder: (context, index) {
                            final user = liste[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ContactUser(user: user),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 4,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          width: 55,
                                          height: 55,
                                          child:
                                              (user.image != null &&
                                                      user.image !=
                                                          'default.png')
                                                  ? Image.network(
                                                    '$imageUrl/${user.image}',
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Image.asset(
                                                        "images/avatar1.jpg",
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  )
                                                  : Image.asset(
                                                    "images/avatar1.jpg",
                                                    fit: BoxFit.cover,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   padding: EdgeInsets.all(3),
                                    //   margin: EdgeInsets.all(4),
                                    //   height: 15,
                                    //   width: 15,
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white,
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.green,
                                    //       shape: BoxShape.circle,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    SizedBox(height: 20),

                    // Liste "Chefs de service"
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 5),
                      child: Text(
                        "Mutualistes",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Obx(() {
                      final liste = _authentificationController.filterPersonnel;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: liste.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final user = liste[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactUser(user: user),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.white,
                              margin: const EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Avatar avec bord circulaire
                                    Container(
                                      width: 80,
                                      height: 80,
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
                                          '$imageUrl/${user.image}',
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
                                    const SizedBox(height: 8),

                                    // Nom complet
                                    Text(
                                      "${user.nom} ${user.prenom}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Téléphone
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            user.telephone ?? 'Non défini',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    // Badge évaluation
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "4.9",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
