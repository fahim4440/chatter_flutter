import 'package:flutter/material.dart';
import 'homeBLoc.dart';
export 'homeBLoc.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc bloc;

  HomeBlocProvider({Key key, Widget child})
    : bloc = HomeBloc(),
      super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static HomeBloc of(context) {
    return (context.inheritFromWidgetOfExactType(HomeBlocProvider) as HomeBlocProvider).bloc;
  }
}