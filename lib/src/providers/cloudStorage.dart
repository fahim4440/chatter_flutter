import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

class CloudStorage {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadPhoto(File image, String user) async {
    StorageReference storageReference = _storage.ref().child('chats/${user}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    String photoUrl = await storageReference.getDownloadURL() as String;
    return photoUrl;
  }
}