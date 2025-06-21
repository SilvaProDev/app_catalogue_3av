import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';
import 'custom_field.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback onLoginTap;
  const SignupScreen({Key? key, required this.onLoginTap}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // États des cases à cocher
  bool _is3AVChecked = false;
  bool _isMUCAFChecked = false;
  bool _isAMCOFChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Color(0xFFF8F9FD),
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'images/logo.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    FadeInDown(
                      duration: Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Créer un compte',
                            style: TextStyle(
                              color: Color(0xFF1D1C1D),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    FadeInUp(
                      duration: Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 200),
                      child: Column(
                        children: [
                          CustomTextField(
                            icon: CupertinoIcons.mail,
                            hint: 'Email',
                            gradientColors: [
                              Color(0xFF4A154B),
                              Color(0xFF6B1A6B),
                            ],
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            icon: CupertinoIcons.person,
                            hint: 'Nom de famille',
                            gradientColors: [
                              Color(0xFF4A154B),
                              Color(0xFF6B1A6B),
                            ],
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            icon: CupertinoIcons.person,
                            hint: 'Prénom',
                            gradientColors: [
                              Color(0xFF4A154B),
                              Color(0xFF6B1A6B),
                            ],
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            icon: CupertinoIcons.lock,
                            hint: 'Mot de passe',
                            isPassword: true,
                            gradientColors: [
                              Color(0xFF4A154B),
                              Color(0xFF6B1A6B),
                            ],
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            icon: CupertinoIcons.lock,
                            hint: 'Confirmer Mot de passe',
                            isPassword: true,
                            gradientColors: [
                              Color(0xFF4A154B),
                              Color(0xFF6B1A6B),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Row des Checkbox
                          FadeInUp(
                            duration: Duration(milliseconds: 600),
                            delay: Duration(milliseconds: 300),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCheckbox("3AV", _is3AVChecked, (bool? value) {
                                  setState(() {
                                    _is3AVChecked = value ?? false;
                                  });
                                }),
                                _buildCheckbox("MUCAF", _isMUCAFChecked, (bool? value) {
                                  setState(() {
                                    _isMUCAFChecked = value ?? false;
                                  });
                                }),
                                _buildCheckbox("AMCOF", _isAMCOFChecked, (bool? value) {
                                  setState(() {
                                    _isAMCOFChecked = value ?? false;
                                  });
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 400),
                      child: CustomButton(
                        onPressed: () {}, 
                        text: 'Créer compte',
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire une Checkbox avec un libellé
  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF4A154B), // Couleur violette pour rester cohérent
        ),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF1D1C1D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}