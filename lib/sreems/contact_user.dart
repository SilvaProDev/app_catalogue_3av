import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart'; // assure-toi que imageUrl vient de là
import '../model/personnel.dart'; // ton PersonnelModel

class ContactUser extends StatelessWidget {
  final PersonnelModel user;
  const ContactUser({super.key, required this.user});

  Color _serviceColor() {
    try {
      final hex = user.couleur ?? '#6B1A6B';
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (_) {
      return const Color(0xFF6B1A6B);
    }
  }

  ImageProvider _avatarImage() {
    if (user.image != null && user.image!.isNotEmpty && user.image != 'default.png') {
      return NetworkImage('$imageUrl/${user.image}');
    } else {
      return const AssetImage('images/default-profil.jpg');
    }
  }

  String _matriculeString() {
    if (user.matricule == null) return 'N/A';
    return user.matricule.toString();
  }

  void _fakeAction(BuildContext context, String label, String? data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label: ${data ?? ''}')));
  }

  @override
  Widget build(BuildContext context) {
    final serviceColor = _serviceColor();
    final avatar = _avatarImage();

    return Scaffold(
      backgroundColor: serviceColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header : back, avatar, name, matricule, menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Back button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Avatar + name
                  Expanded(
                    child: Row(
                      children: [
                        Hero(
                          tag: 'avatar_${user.id}',
                          child: CircleAvatar(radius: 34, backgroundImage: avatar),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.nom} ${user.prenom}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                     fontSize: 16, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // const SizedBox(height: 4),
                                // Chip(
                                //   backgroundColor: Colors.white24,
                                //   avatar: const Icon(Icons.badge, color: Colors.white, size: 18),
                                //   label: Text(
                                //     _matriculeString(),
                                //     style: const TextStyle(color: Colors.white),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // More actions
                  // InkWell(
                  //   onTap: () {
                  //     showModalBottomSheet(
                  //       context: context,
                  //       builder: (_) => _bottomSheetActions(context, serviceColor),
                  //     );
                  //   },
                  //   child: const CircleAvatar(
                  //     radius: 18,
                  //     backgroundColor: Colors.black26,
                  //     child: Icon(Icons.more_vert, color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Body (white rounded area)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick action buttons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     _actionCircle(
                      //       icon: Icons.call,
                      //       label: 'Appeler',
                      //       color: serviceColor,
                      //       onTap: () => _fakeAction(context, 'Appel', user.telephone),
                      //     ),
                      //     _actionCircle(
                      //       icon: CupertinoIcons.chat_bubble_text_fill,
                      //       label: 'Message',
                      //       color: serviceColor,
                      //       onTap: () => _fakeAction(context, 'SMS', user.telephone),
                      //     ),
                      //     _actionCircle(
                      //       icon: Icons.email,
                      //       label: 'E-mail',
                      //       color: serviceColor,
                      //       onTap: () => _fakeAction(context, 'E-mail', user.email),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 20),

                      // Informations card
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Informations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 10),
                              _infoTile(Icons.phone, 'Téléphone', user.telephone ?? 'Non renseigné'),
                              const Divider(),
                              _infoTile(Icons.email, 'E-mail', user.email ?? 'Non renseigné'),
                              const Divider(),
                              
                              _infoTile(Icons.badge, 'Matricule', _matriculeString()),
                              const Divider(),
                              // _infoTile(Icons.work_outline, 'Rôle', user.libelleRole ?? 'N/R'),
                              // const Divider(),
                              _infoTile(Icons.work_outline, 'Fonction', user.fonction ?? 'N/R'),
                              const Divider(),
                              _infoTile(Icons.work_outline, 'Emploi', user.emploi ?? 'N/R'),
                              const Divider(),
                              _infoTile(Icons.work_outline, 'Grade', user.grade ?? 'N/R'),
                             
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Bottom actions
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ElevatedButton.icon(
                      //         style: ElevatedButton.styleFrom(backgroundColor: serviceColor),
                      //         onPressed: () => _fakeAction(context, 'Modifier', user.id.toString()),
                      //         icon: const Icon(Icons.edit),
                      //         label: const Text('Modifier'),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 12),
                      //     Expanded(
                      //       child: OutlinedButton.icon(
                      //         style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
                      //         onPressed: () => _confirmDelete(context),
                      //         icon: const Icon(Icons.delete_outline),
                      //         label: const Text('Supprimer'),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCircle({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundColor: Colors.grey.shade100, child: Icon(icon, color: Colors.black54, size: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ]),
        ),
      ],
    );
  }

  Widget _bottomSheetActions(BuildContext context, Color serviceColor) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Appeler'),
            onTap: () {
              Navigator.pop(context);
              _fakeAction(context, 'Appel', user.telephone);
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.chat_bubble_text_fill),
            title: const Text('Message'),
            onTap: () {
              Navigator.pop(context);
              _fakeAction(context, 'SMS', user.telephone);
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('E-mail'),
            onTap: () {
              Navigator.pop(context);
              _fakeAction(context, 'E-mail', user.email);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Partager'),
            onTap: () {
              Navigator.pop(context);
              _fakeAction(context, 'Partager', '${user.prenom} ${user.nom} — ${_matriculeString()}');
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer cet utilisateur ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _fakeAction(context, 'Supprimé', user.id.toString());
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}
