import 'package:flutter/material.dart';
import '../providers/repository.dart';
import '../models/chatListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/chatscreen.dart';
import 'circularProgressIndicator.dart';
import 'homeListTile.dart';
import '../blocs/homeBlocProvider.dart';

class HomeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _repository = Repository();
    final bloc = HomeBlocProvider.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[200],
      child: StreamBuilder(
        stream: bloc.chatRooms,
        builder: (context, AsyncSnapshot<List<ChatListModel>> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgress();
          }
          if (snapshot.data.length == 0) {
            return Container(
              color: Colors.grey[100],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Tap '),
                  Icon(Icons.message),
                  Text(' to message'),
                ],
              ),
            );
          }
          List<ChatListModel> list = snapshot.data.reversed.toList();
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, int index) {
              String name2 = list[index].name;
              String email2 = list[index].email;
              String photoUrl2 = list[index].photoUrl;
              String roomId = list[index].roomId;
              return GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String email = prefs.getString('email');
                  Navigator.push(context, MaterialPageRoute(
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
                },
                child: FutureBuilder(
                  future: _repository.fetchLastMsg(roomId),
                  builder: (context, lastMsgSnapshot) {
                    if (!lastMsgSnapshot.hasData) {
                      return Container();
                    }
                    return HomeListTile(
                      photoUrl: photoUrl2,
                      name: name2,
                      lastMsg: lastMsgSnapshot.data[0],
                      lastMsgTime: lastMsgSnapshot.data[1],
                      isSendbyMe: email2 == lastMsgSnapshot.data[2] ? false : true,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  
}