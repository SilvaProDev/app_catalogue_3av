import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/navbar_roots.dart';
import 'custom_button.dart';
import 'custom_field.dart';
import 'director_word.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required Null Function() onLoginTap})
    : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthentificationController _authentificationController = Get.put(
    AuthentificationController(),
  );
  bool _isLoading = false; // Ajout d'un état de chargement

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FD),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('images/logo.jpg', fit: BoxFit.cover),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    FadeInDown(
                      duration: Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 150,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'images/logo.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Connexion',
                              style: TextStyle(
                                color: Color(0xFF1D1C1D),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                fontSize: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 200),
                      child: Column(
                        children: [
                          CustomTextField(
                            icon: CupertinoIcons.person_crop_rectangle,
                            hint: 'Matricule',
                            controller: _matriculeController,
                            gradientColors: [
                              Color(0xFF4A154B),
                              Color(0xFF6B1A6B),
                            ],
                          ),
                          SizedBox(height: 30),
                          CustomTextField(
                            icon: CupertinoIcons.lock,
                            hint: 'Password',
                            controller: _passwordController,
                            isPassword: true,
                            gradientColors: [
                              Color(0xFF4A154B),
                              Color(0xFF6B1A6B),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    FadeInUp(
                      duration: Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 400),
                      child:
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : CustomButton(
                                onPressed: () async {
                                  if (_matriculeController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    Get.snackbar(
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      'Erreur',
                                      'Veuillez remplir tous les champs',
                                      snackPosition: SnackPosition.TOP,
                                    );
                                    return;
                                  }

                                  setState(() => _isLoading = true);

                                  try {
                                    await _authentificationController.login(
                                      matricule: _matriculeController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );

                                    // Si la connexion réussit, naviguer vers l'écran d'accueil
                                   // Get.offAll(() => NavBarRoots());
                                  } catch (e) {
                                    Get.snackbar(
                                      'Erreur',
                                      'Échec de la connexion: ${e.toString()}',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
                                },
                                text: 'Se connecter',
                              ),
                    ),
                         SizedBox(height: 40),
                    FadeInUp(
                      duration: Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 800),
                      child: Column(
                        children: [
                          Row(
                            children: [
                            
                            ],
                          ),
                          
                          SizedBox(height: 200),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
