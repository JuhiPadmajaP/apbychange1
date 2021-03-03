import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.userName, this.isMe, {this.key});
  final Key key;
  final String message;
  final String userName;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[200]
                    : Theme.of(context).toggleableActiveColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                  bottomLeft: isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 11,
                horizontal: 17,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1
                                  .color),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                          color: isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1
                                  .color),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                    )
                  ]))
        ]);
  }
}
