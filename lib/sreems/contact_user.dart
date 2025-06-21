import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class ContactUser extends StatelessWidget {
  final User user;
  ContactUser({super.key, required this.user});

  List imgs = [
    "doctor1.jpg",
    "doctor2.jpg",
    "doctor3.jpg",
    "doctor4.jpeg",
    "doctor3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
        int.parse(user.service.couleur.replaceFirst('#', '0xff')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("images/${user.image}"),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "${user.prenom} ${user.nom}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${user.numero}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    user.service.couleur.replaceFirst(
                                      '#',
                                      '0xff',
                                    ),
                                  ),
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.call,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    user.service.couleur.replaceFirst(
                                      '#',
                                      '0xff',
                                    ),
                                  ),
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.chat_bubble_text_fill,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              padding: EdgeInsets.only(top: 20, left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Plus d info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Le Lorem Ipsum est simplement du faux texte employé dans la",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  SizedBox(height: 30),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                // blurRadius: 1,
                                // spreadRadius: 1
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: AssetImage(
                                      "images/${imgs[index]}",
                                    ),
                                  ),
                                  title: Text(
                                    "Mr Silva",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text("1 min"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon( 
                                        Icons.star,
                                        color: Color(
                                          int.parse(
                                            user.service.couleur.replaceFirst(
                                              '#',
                                              '0xff',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(
                                          int.parse(
                                            user.service.couleur.replaceFirst(
                                              '#',
                                              '0xff',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "4.9",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),

                                  child: Text(
                                    "Agent vérificateur",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Localisation",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF0EEFA),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 30,
                        color: Color(
                          int.parse(
                            user.service.couleur.replaceFirst('#', '0xff'),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      "Cocody angre",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Cocody angre non loin des oscars"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
