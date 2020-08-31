import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'userGoogleApi.dart';
import 'firestoreApi.dart';
import '../models/userModel.dart';
import '../models/chatListModel.dart';
import 'authResultStatus.dart';
import 'cloudStorage.dart';
import 'dart:io';

class Repository {
  final _googleApi = UserGoogleApi();
  final _fireStoreProvider = FireStoreApi();
  final _storage = CloudStorage();

  Future<AuthResultStatus> signUp(String name, String email, String password) async {
    final status = await _googleApi.signUp(name, email, password);
    if (status == AuthResultStatus.successful) {
      await _fireStoreProvider.createUserData(name, email, 'null');
      await addUsertoSharedPref(name, email, 'null');
    }
    return status;
  }
  Future<AuthResultStatus> signIn(String email, String password) async {
    final status = await _googleApi.signIn(email, password);
    if (status == AuthResultStatus.successful) {
      QuerySnapshot snapshot =  await _fireStoreProvider.fetchUserData(email);
      await snapshot.docs.forEach((element) async {
        UserModel user = UserModel.fromFirebase(element.data());
        await addUsertoSharedPref(user.name, user.email, user.photoUrl);
      });
    }
    return status;
  }

  Future<Map<int, UserModel>> fetchUserSearchData(String name) async {
    Map<int, UserModel> cache = {};
    int index = 0;
    QuerySnapshot snapshot =  await _fireStoreProvider.fetchUserSearchData(name);
    snapshot.docs.forEach((element) {
      UserModel user = UserModel.fromFirebase(element.data());
      cache[index] = user;
      index++;
    });
    return cache;
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final user = await _googleApi.signInWithGoogle();
      if (user != null) {
        QuerySnapshot snapshot =  await _fireStoreProvider.fetchUserData(user.email);
        if (snapshot.docs.length == 0) {
          await _fireStoreProvider.createUserData(user.name, user.email, user.photoUrl);
        }
        await addUsertoSharedPref(user.name, user.email, user.photoUrl);
      }
      return user;
    } catch(error) {

    }
  }


  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', '');
    prefs.setString('email', '');
    prefs.setString('photoUrl', '');
    prefs.setBool('isLoggedIn', false);
    _googleApi.signOut();
  }


  createRoom(String username1, String email1, String photoUrl1, String username2, String email2, String photoUrl2) async {
    await _fireStoreProvider.createRoom(username1, email1, photoUrl1, username2, email2, photoUrl2);
  }

  Future<List<ChatListModel>> fetchChatRoomList() async {
    return await _fireStoreProvider.fetchChatRoomList();
  }

  Future<List<String>> fetchLastMsg(String roomId) async {
    return await _fireStoreProvider.fetchLastMsg(roomId);
  }

  sendMessage(String msg, String sender, String receiver, String docId) {
    _fireStoreProvider.sendMessage(msg, sender, receiver, docId);
  }

  updateName(String email, String updateName) async {
    await _fireStoreProvider.updateName(email, updateName);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('name', updateName);
  }
  updatePhoto(String email, String updatePhotoUrl) async {
    await _fireStoreProvider.updatePhotoUrl(email, updatePhotoUrl);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('photoUrl', updatePhotoUrl);
  }


  addUsertoSharedPref(String name, String email, String photoUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('photoUrl', photoUrl);
    prefs.setBool('isLoggedIn', true);
  }

  Future<String> uploadPhoto(File image, String user) async {
    return _storage.uploadPhoto(image, user);
  }
}