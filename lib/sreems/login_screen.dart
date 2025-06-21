import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/navbar_roots.dart';
import 'custom_button.dart';
import 'custom_field.dart';
import 'director_word.dart';

class LoginScreen extends StatelessWidget {
  // final VoidCallback onSignUpTap;
  const LoginScreen({Key? key, required Null Function() onLoginTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FD),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              
              opacity: 0.2, // Ajustez l'opacité selon vos besoins
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
                                  )
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
                          SizedBox(height: 16),
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
                            icon: CupertinoIcons.mail,
                            hint: 'Email',
                            gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            icon: CupertinoIcons.lock,
                            hint: 'Password',
                            isPassword: true,
                            gradientColors: [Color(0xFF4A154B), Color(0xFF6B1A6B)],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 400),
                      child: CustomButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DirectorWord()),
                          );
                        },
                        text: 'Se connecter',
                      ),
                    ),
                    SizedBox(height: 24),
                    FadeIn(
                      duration: Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // children: [
                        //   Text(
                        //     "Avez-vous déjà un compte ? ",
                        //     style: TextStyle(color: Color(0xFF1D1C1D)),
                        //   ),
                        //   GestureDetector(
                        //     onTap: (){},
                        //     child: Text(
                        //       'S\'inscrire',
                        //       style: TextStyle(
                        //         color: Color(0xFF4A154B),
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ],
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
                              // Expanded(
                              //   child: Container(
                              //     height: 1,
                              //     decoration: BoxDecoration(
                              //       gradient: LinearGradient(
                              //         colors: [
                              //           Colors.transparent,
                              //           Color(0xFFE0E0E0),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 16),
                              //   child: Text(
                              //     "Connectez-vous avec",
                              //     style: TextStyle(
                              //       color: Color(0xFF1D1C1D),
                              //       fontWeight: FontWeight.w500,
                              //     ),
                              //   ),
                              // ),
                              // Expanded(
                              //   child: Container(
                              //     height: 1,
                              //     decoration: BoxDecoration(
                              //       gradient: LinearGradient(
                              //         colors: [
                              //           Colors.transparent,
                              //           Color(0xFFE0E0E0),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          // SizedBox(height: 30),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     ElasticIn(
                          //       duration: Duration(milliseconds: 800),
                          //       delay: Duration(milliseconds: 1000),
                          //       child: _buildSocialButton(
                          //         icon: Icons.g_mobiledata,
                          //         label: 'Google',
                          //         gradientColors: [
                          //           Color(0xFFDB4437),
                          //           Color(0xFFF66D5B),
                          //         ],
                          //       ),
                          //     ),
                          //     ElasticIn(
                          //       duration: Duration(milliseconds: 800),
                          //       delay: Duration(milliseconds: 1200),
                          //       child: _buildSocialButton(
                          //         icon: Icons.apple,
                          //         label: 'Apple',
                          //         gradientColors: [
                          //           Color(0xFF000000),
                          //           Color(0xFF2C2C2C),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
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

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
  }) {
    return Container(
      height: 55,
      width: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors[0].withOpacity(0.1),
            gradientColors[1].withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: gradientColors[0]),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: gradientColors[0],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}