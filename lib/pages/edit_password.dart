import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/auth_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
final AuthentificationController _authentificationController = Get.put(AuthentificationController(),
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

 
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(
      content: Text(message), backgroundColor: color));
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _authentificationController.changePassword(
        
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (result["status"] == 200) {
        _showMessage(result["data"]["message"], Colors.green);
        await _authentificationController.logout();
      } else {
        _showMessage(
          result["data"]["message"] ?? "Erreur inconnue",
          Colors.red,
        );
      }
    } catch (e) {
      _showMessage("Erreur de connexion : $e", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

 

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Changer le mot de passe",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Mot de passe actuel
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: _inputDecoration("Mot de passe actuel", Icons.lock),
                validator:
                    (value) =>
                        value!.isEmpty
                            ? "Veuillez entrer votre mot de passe actuel"
                            : null,
              ),
              const SizedBox(height: 16),

              // Nouveau mot de passe
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: _inputDecoration(
                  "Nouveau mot de passe",
                  Icons.password,
                ),
                validator:
                    (value) =>
                        value!.length < 8
                            ? "Le mot de passe doit contenir au moins 8 caractères"
                            : null,
              ),
              const SizedBox(height: 16),

              // Confirmation
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration(
                  "Confirmer le mot de passe",
                  Icons.check_circle,
                ),
                validator:
                    (value) =>
                        value != _newPasswordController.text
                            ? "Les mots de passe ne correspondent pas"
                            : null,
              ),
              const SizedBox(height: 30),

              // Bouton
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue.shade700,
                  ),
                  onPressed: _isLoading ? null : _handleChangePassword,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Modifier le mot de passe",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
