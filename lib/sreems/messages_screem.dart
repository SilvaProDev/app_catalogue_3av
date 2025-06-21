import 'package:flutter/material.dart';

import 'chat_screem.dart';

class MessageScreem extends StatelessWidget {
  MessageScreem({super.key});
  List imgs = [
    "doctor1.jpg",
    "doctor2.jpg",
    "doctor3.jpg",
    "doctor4.jpeg",
    "doctor1.jpg",
    "doctor2.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Messagerie",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height: 40),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   child: Text(
            //     "Messages",
            //     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            //   ),
            // ),
            SizedBox(height: 30),
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Recherche",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Color(0xFF7165D6)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                "En ligne",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: imgs.length,
                itemBuilder: (context, index) {
                  return Container(
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
                          child: Container(
                            height: 65,
                            width: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "images/${imgs[index]}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          margin: EdgeInsets.all(4),
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                "Message recent",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreem()),
                        );
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("images/${imgs[index]}"),
                    ),
                    title: Text(
                      "Da Silva",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Bjr Silva ! Comment vous allez",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    trailing: Text(
                      "12:30",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
