import 'package:flutter/material.dart';
import 'profilePicture.dart';

class HomeListTile extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String lastMsg;
  final String lastMsgTime;
  final bool isSendbyMe;

  HomeListTile({this.photoUrl, this.name, this.lastMsg, this.lastMsgTime, this.isSendbyMe});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ProfilePicture(
                width: 60.0,
                height: 60.0,
                photoUrl: photoUrl,
                topMargin: 0.0,
              ),
              SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 25.0,
                    margin: EdgeInsets.only(top: 5.0, bottom: 2.0, left: 10.0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 20.0,
                    margin: EdgeInsets.only(left: 10.0),
                    child: lastMsgShow(isSendbyMe, lastMsg)
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 15.0,
                    child: Text(
                      lastMsgTime,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12.0
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
  Widget lastMsgShow(bool isSendbyMe, lastMsg) {
    return isSendbyMe ? Row(
      children: <Widget>[
        Text(
          'You: ',
          style: TextStyle(
              fontSize: 15.0,
              color: Colors.black45,
              fontStyle: FontStyle.italic
          ),
          textAlign: TextAlign.start,
        ),
        Text(
          lastMsg,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black45,
            fontStyle: FontStyle.italic
          ),
          textAlign: TextAlign.start,
        ),
      ],
    ) : Row(
      children: <Widget>[
        Text(''),
        Text(
          lastMsg,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black45,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}