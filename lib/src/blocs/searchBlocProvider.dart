import 'package:flutter/material.dart';
import 'searchBloc.dart';
export 'searchBloc.dart';

class SearchBlocProvider extends InheritedWidget{
  final SearchBloc bloc;

  SearchBlocProvider({Key key, Widget child})
    : bloc = SearchBloc(),
      super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static SearchBloc of(context) {
    return (context.inheritFromWidgetOfExactType(SearchBlocProvider) as SearchBlocProvider).bloc;
  }
}