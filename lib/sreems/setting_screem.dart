import 'package:catalogue_3av/pages/finances.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';
import '../controllers/auth_controller.dart';
import '../pages/demande_pret.dart';
import '../pages/edit_password.dart';
import '../pages/edit_profile_screen.dart';
import '../pages/prestation.dart';
import '../pages/profil_page.dart';
import '../pages/suivi_de_pret.dart';
import 'dashbord_screem.dart';
import 'login_screen.dart';
import 'messages_screem.dart';
import 'signup_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
      final AuthentificationController _authentificationController =
      Get.put(AuthentificationController());
  @override
  Widget build(BuildContext context) {
    // Styles de texte réutilisables
    final TextStyle titleStyle = GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.deepPurple,
    );

    final TextStyle tileTitleStyle = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.grey[800],
    );

    final TextStyle profileNameStyle = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Paramètres",
                style: titleStyle,
              ),
              const SizedBox(height: 20),
              
              // Section Profil
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:  CircleAvatar(
                          radius: 30,
                          backgroundImage: (_authentificationController.user.value?.image != null &&
                                  _authentificationController.user.value!.image!.isNotEmpty)
                              ? NetworkImage('${imageUrl}/${_authentificationController.user.value!.image!}')
                                  as ImageProvider
                              : const AssetImage("images/doctor1.jpg"),
                       
                        ),
                        title: Text(
                          _authentificationController
                                            .user.value?.nom as String,
                          style: profileNameStyle,
                        ),
                        subtitle: Text(
                          "Voir le profil",
                          style: GoogleFonts.roboto(color: Colors.blue),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfileScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildProfileAction(
                            icon: Icons.edit,
                            label: "Modifier",
                            color: Colors.blue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileScreen()),
                              );
                            },
                          ),
                          // _buildProfileAction(
                          //   icon: Icons.message,
                          //   label: "Messages",
                          //   color: Colors.green,
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => MessageScreem()),
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Section Paramètres
              Text(
                "Navigation",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 15),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildSettingTile(
                      context,
                      icon: Icons.edit,
                      title: "Modifier mot de passe",
                      color: Colors.deepPurple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordPage()),
                        );
                      },
                    ),
                    // _buildSettingTile(
                    //   context,
                    //   icon: Icons.dashboard,
                    //   title: "Tableau de bord",
                    //   color: Colors.deepPurple,
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => DashboardScreen()),
                    //     );
                    //   },
                    // ),
                    _buildDivider(),
                    // _buildSettingTile(
                    //   context,
                    //   icon: Icons.trending_up,
                    //   title: "Finances",
                    //   color: Colors.indigo,
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => MemberLoansScreen()),
                    //     );
                    //   },
                    // ),
                    _buildSettingTile(
                      context,
                      icon: Icons.account_balance_wallet,
                      title: "Prestations",
                      color: Colors.indigo,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrestationsScreen()),
                        );
                      },
                    ),
                    _buildSettingTile(
                      context,
                      icon: Icons.timeline,
                      title: "suivre mon prêt",
                      color: Colors.indigo,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuiviPretsPage()),
                        );
                      },
                    ),
                    _buildDivider(),
                    // _buildSettingTile(
                    //   context,
                    //   icon: Icons.person_add,
                    //   title: "Enregistrer un membre",
                    //   color: Colors.orange,
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => SignupScreen(onLoginTap: () {}),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Section Compte
              Text(
                "Compte",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 15),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // _buildSettingTile(
                    //   context,
                    //   icon: Icons.settings,
                    //   title: "Paramètres du compte",
                    //   color: Colors.grey,
                    //   onTap: () {},
                    // ),
                    _buildDivider(),
                    _buildSettingTile(
                      context,
                      icon: Icons.help_outline,
                      title: "Charte 3AV",
                      color: Colors.blueGrey,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      context,
                      icon: Icons.logout,
                      title: "Déconnexion",
                      color: Colors.redAccent,
                       onTap: () async {
                   await _authentificationController.logout();
                  },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey[200]),
    );
  }

  Widget _buildProfileAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Colors.grey[400],
      ),
    );
  }
}