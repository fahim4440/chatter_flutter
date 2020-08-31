import '../providers/repository.dart';
import '../models/chatListModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc {
  final _repository = Repository();
  final _chatRooms = PublishSubject<List<ChatListModel>>();
  final _status = PublishSubject<bool>();
  final _user = BehaviorSubject<List<String>>();

  //streams
  Stream<List<ChatListModel>> get chatRooms => _chatRooms.stream;
  Stream<bool> get isLoggedIn => _status.stream;
  Stream<List<String>> get user => _user.stream;

  //Sinks
  fetchChatRooms() async {
    final list = await _repository.fetchChatRoomList();
    _chatRooms.sink.add(list);
  }

  fetchisLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool status = preferences.getBool('isLoggedIn');
    if (status == null) {
      status = false;
    }
    _status.sink.add(status);
  }

  fetchUserFromSharedPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String name = await preferences.getString('name');
    final String email = await preferences.getString('email');
    final String photoUrl = await preferences.getString('photoUrl');
    List<String> list = [name, email, photoUrl];
    _user.sink.add(list);
  }

  dispose() {
    _chatRooms.close();
  }
}