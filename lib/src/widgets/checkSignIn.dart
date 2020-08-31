import 'package:flutter/material.dart';
import '../blocs/homeBlocProvider.dart';
import 'circularProgressIndicator.dart';
import '../screens/home.dart';
import '../screens/signin.dart';

class CheckSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = HomeBlocProvider.of(context);
    return StreamBuilder(
      stream: bloc.isLoggedIn,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgress();
        }
        return snapshot.data ? Home() : SignIn();
      }
    );
  }
}