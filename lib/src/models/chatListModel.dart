class ChatListModel {
  final String name;
  final String email;
  final String photoUrl;
  final String roomId;
  final String lastMsg;
  final DateTime lastMsgTime;

  ChatListModel.fromFirebase(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        email = parsedJson['email'],
        photoUrl = parsedJson['photoUrl'],
        roomId = parsedJson['roomId'],
        lastMsg = parsedJson['lastMsg'],
        lastMsgTime = parsedJson['lastMsgTime'];
}
