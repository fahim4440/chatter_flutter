import 'package:flutter/material.dart';
import 'signInBloc.dart';
export 'signInBloc.dart';

class SignInProvider extends InheritedWidget {
  final SignInBloc bloc;

  SignInProvider({Key key, Widget child})
    : bloc = SignInBloc(),
      super(key: key, child: child);
  bool updateShouldNotify(_) => true;

  static SignInBloc of(context) {
    return (context.inheritFromWidgetOfExactType(SignInProvider) as SignInProvider).bloc;
  }
}