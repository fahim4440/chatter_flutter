import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/userModel.dart';
import 'authResultStatus.dart';
import 'authExceptionHandler.dart';

class UserGoogleApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResultStatus _status;


  Future<AuthResultStatus> signUp(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status =AuthResultStatus.undefined;
      }
    } catch(error) {
      _status = AuthExceptionHandler.handleException(error);
    }
    return _status;
  }

  Future<AuthResultStatus> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status =AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;
    final Map<String, dynamic> parsedJson = {
      "name": user.displayName.toString(),
      "email": user.email.toString(),
      "photoUrl": user.photoURL.toString(),
    };
    return UserModel.fromFirebase(parsedJson);
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
