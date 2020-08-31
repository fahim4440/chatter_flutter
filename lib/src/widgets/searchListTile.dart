import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/firestoreApi.dart';
import '../screens/chatscreen.dart';
import 'profilePicture.dart';

class SearchListTile extends StatelessWidget {
  final String name2;
  final String email2;
  final String photoUrl2;

  SearchListTile({this.email2, this.name2, this.photoUrl2});

  @override
  Widget build(BuildContext context) {
    final _fireStore = FireStoreApi();
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String name = prefs.getString('name');
        String email = prefs.getString('email');
        String photoUrl = prefs.getString('photoUrl');
        if (email != email2) {
          await _fireStore.createRoom(name, email, photoUrl, name2, email2, photoUrl2);
          String roomId = await prefs.getString('roomId');
          print('chatscreen $roomId');
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  receiverName: name2,
                  receiverEmail: email2,
                  senderEmail: email,
                  receiverPhotoUrl: photoUrl2,
                  roomId: roomId,
                );
              }
          ));
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: Row(
              children: <Widget>[
                ProfilePicture(
                  width: 50.0,
                  height: 50.0,
                  topMargin: 0.0,
                  photoUrl: photoUrl2,
                ),
                SizedBox(width: 10.0,),
                Text(
                  '${name2}',
                  style: TextStyle(
                      fontSize: 18.0
                  ),
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}