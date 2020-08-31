import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/repository.dart';
import '../widgets/profilePicture.dart';
import '../widgets/message.dart';

class ChatScreen extends StatelessWidget {
  final String receiverName;
  final String receiverPhotoUrl;
  final String receiverEmail;
  final String senderEmail;
  final String roomId;

  ChatScreen({this.receiverName, this.receiverEmail, this.senderEmail, this.receiverPhotoUrl, this.roomId});

  final _repository = Repository();
  String msg = '';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: AppBarCustom()
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chatRooms').doc(roomId).collection('chats').orderBy('time', descending: false).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, int index) {
                      bool isSendbyMe = false;
                      if(senderEmail == snapshot.data.docs[index].data()['sender']) {
                        isSendbyMe = true;
                      }
                      String msg = snapshot.data.docs[index].data()['message'];
                      return Message(
                        msg: msg,
                        isSendbyMe: isSendbyMe,
                      );
                    },
                  );
                },
              ),
            ),
            bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget AppBarCustom() {
    return Center(
      child: Row(
        children: <Widget>[
          ProfilePicture(
            width: 40.0,
            height: 40.0,
            topMargin: 0.0,
            photoUrl: receiverPhotoUrl,
          ),
          Container(
            margin: EdgeInsets.only(top: 14.0),
            height: 50.0,
            width: 150.0,
            child: Column(
              children: <Widget>[
                Text(
                  receiverName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0
                  ),
                ),
                Text(
                  'Last active',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white60
                  ),
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Form(
              key: formKey,
              child: TextFormField(
                onSaved: (String value) {
                  msg = value;
                  value = '';
                },
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                    fontSize: 18.0
                ),
                cursorColor: Colors.blueGrey,
                decoration: InputDecoration(
                  hintText: 'Type here...',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blueGrey
                      ),
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blueGrey
                      ),
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5.0,),
          GestureDetector(
            onTap: () async {
              formKey.currentState.save();
              if(msg.trim() != '') {
                _repository.sendMessage(msg.trim(), senderEmail, receiverEmail, roomId);
                msg = '';
                formKey.currentState.reset();
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: 25.0,
              child: Icon(
                Icons.send,
                size: 30.0,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
  
}