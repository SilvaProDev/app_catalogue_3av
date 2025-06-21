import 'package:flutter/material.dart';

import '../widgets/chat_sample.dart';

class ChatScreem extends StatelessWidget {
  const ChatScreem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color(0xFF7165D6),
          leadingWidth: 30,
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("images/doctor1.jpg"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Mr Ouattara",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 5, right: 10),
              child: Icon(Icons.call, color: Colors.white, size: 26),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, right: 10),
              child: Icon(Icons.video_call, color: Colors.white, size: 26),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, right: 10),
              child: Icon(Icons.more_vert, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
        itemBuilder: (contex, index) => ChatSample(),
      ),
      bottomSheet: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.add, size: 20),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(
                Icons.emoji_emotions_outlined,
                size: 20,
                color: Colors.amber,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.4,
                alignment: Alignment.centerRight,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Type something",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.send, size: 30, color: Color(0xFF7165D6),),
            )
          ],
        ),
        
      ),
    );
  }
}
