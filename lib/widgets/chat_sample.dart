import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';


class ChatSample extends StatelessWidget {
  const ChatSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 80, top: 10),
          child: ClipPath(
            clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFE1E1E2),
              ),
              child: Text(
                "Bjr ouattara Comment vous allez ?",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 80, right: 10),
        child: ClipPath(
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
          child: Container(
            padding: EdgeInsets.only(
              left: 20, top: 10, bottom: 25, right: 20
            ),
            decoration: BoxDecoration(
              color: Color(0xFF7165D6),
            ),
            child: Text(
              "Hello Doctor, Are you there ?",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    )
      ],
    );
  }
}
