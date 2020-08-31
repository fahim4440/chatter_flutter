import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chatListModel.dart';

class FireStoreApi {
  final _fireStore = FirebaseFirestore.instance;

  List<String> setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
  
  createUserData(String name, String email, String photoUrl) {
    _fireStore.collection('users').add({
      "name" : name,
      "email" : email,
      "photoUrl" : photoUrl,
      "caseSearch": setSearchParam(name),
    });
  }

  fetchUserData(String email) async {
    return await _fireStore.collection('users').where("email", isEqualTo: email).get();
  }

  fetchUserSearchData(String name) async {
    return await _fireStore.collection('users').where("caseSearch", arrayContains: name).get();
  }

  Future<String> fetchDocIdOfUser(String email) async {
    QuerySnapshot querySnapshot = await _fireStore.collection('users').where('email', isEqualTo: email).get();
    return querySnapshot.docs[0].id;
  }

  updateName(String email, String updateName) async {
    String id = await fetchDocIdOfUser(email);
    await _fireStore.collection('users').doc(id).update({
      'name' : updateName,
      'caseSearch' : setSearchParam(updateName),
    });

    QuerySnapshot querySnapshot = await _fireStore.collection('chatRooms').where('user', arrayContains: email).get();
    querySnapshot.docs.forEach((element) async {
      if (element.data()['user'][1] == email) {
        List<dynamic> list = element.data()['user'];
        list[0] = updateName;
        await _fireStore.collection('chatRooms').doc(element.id).update({
          'user' : list
        });
      } else {
        List<dynamic> list = element.data()['user'];
        list[3] = updateName;
        await _fireStore.collection('chatRooms').doc(element.id).update({
          'user' : list
        });
      }
    });
  }

  updatePhotoUrl(String email, String updatePhotoUrl) async {
    String id = await fetchDocIdOfUser(email);
    await _fireStore.collection('users').doc(id).update({
      'photoUrl' : updatePhotoUrl,
    });

    QuerySnapshot querySnapshot = await _fireStore.collection('chatRooms').where('user', arrayContains: email).get();
    querySnapshot.docs.forEach((element) async {
      if (element.data()['user'][1] == email) {
        List<dynamic> list = element.data()['user'];
        list[2] = updatePhotoUrl;
        await _fireStore.collection('chatRooms').doc(element.id).update({
          'user' : list
        });
      } else {
        List<dynamic> list = element.data()['user'];
        list[5] = updatePhotoUrl;
        await _fireStore.collection('chatRooms').doc(element.id).update({
          'user' : list
        });
      }
    });
  }

  createRoom(String username1, String email1, String photoUrl1, String username2, String email2, String photoUrl2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    QuerySnapshot snapshot = await _fireStore.collection('chatRooms').where('user', isEqualTo: [username2, email2, photoUrl2, username1, email1, photoUrl1]).get();
    if (snapshot.docs.length == 0) {
      snapshot = await _fireStore.collection('chatRooms').where('user', isEqualTo: [username1, email1, photoUrl1, username2, email2, photoUrl2]).get();
      if (snapshot.docs.length == 0) {
        DocumentReference doc = await _fireStore.collection('chatRooms').add({
          'user': [username1, email1, photoUrl1, username2, email2, photoUrl2],
        });
        await prefs.setString('roomId', doc.id);
      } else {
        await prefs.setString('roomId', snapshot.docs[0].id);
      }
    } else {
      await prefs.setString('roomId', snapshot.docs[0].id);
    }
  }

  Future<List<ChatListModel>> fetchChatRoomList() async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('email');
    List<ChatListModel> cache = [];
    QuerySnapshot querySnapshot = await _fireStore.collection('chatRooms').where('user', arrayContains: user).get();
    await querySnapshot.docs.forEach((element) async {
      if (element.data()['user'][1] != user) {
        cache.add(ChatListModel.fromFirebase({
          'name' : element.data()['user'][0],
          'email' : element.data()['user'][1],
          'photoUrl' : element.data()['user'][2],
          'roomId' : element.id,
        }));
      } else {
        cache.add(ChatListModel.fromFirebase({
          'name' : element.data()['user'][3],
          'email' : element.data()['user'][4],
          'photoUrl' : element.data()['user'][5],
          'roomId' : element.id,
        }));
      }
    });
    return cache;
  }
  
  Future<List<String>> fetchLastMsg(String roomId) async {
    QuerySnapshot querySnapshot = await _fireStore.collection('chatRooms').doc(roomId).collection('chats').orderBy('time', descending: true).get();
    List<String> last = [];
    last.add(querySnapshot.docs[0].data()['message']);
    String timeDb = querySnapshot.docs[0].data()['time'].toDate().toString().substring(10, 16);
    String time = '';
    if (int.parse(timeDb.substring(0, 3)) > 12) {
      time = (int.parse(timeDb.substring(0, 3)) - 12).toString() + timeDb.substring(3, 6) + ' pm';
    } else {
      time = timeDb + ' am';
    }
    last.add(time);
    last.add(querySnapshot.docs[0].data()['sender']);
    return last;
  }
  
  sendMessage(String msg, String sender, String receiver, String docId) {
    _fireStore.collection('chatRooms').doc(docId).collection('chats').add({
      'message' : msg,
      'sender' : sender,
      'receiver' : receiver,
      'time' : FieldValue.serverTimestamp(),
    });
  }
}