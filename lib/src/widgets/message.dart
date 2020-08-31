import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String msg;
  final bool isSendbyMe;

  Message({this.msg, this.isSendbyMe});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: isSendbyMe ? EdgeInsets.only(top: 5.0, bottom: 5.0, left: 100.0) : EdgeInsets.only(top: 5.0, bottom: 5.0, right: 100.0),
          width: MediaQuery.of(context).size.width,
          alignment: isSendbyMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            decoration: BoxDecoration(
                color: isSendbyMe ? Colors.blueGrey : Colors.black38,
                borderRadius: isSendbyMe ? BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomLeft: Radius.circular(23.0)
                ) : BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomRight: Radius.circular(23.0)
                )
            ),
            child: Text(
              msg,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }
  
}