import 'package:rxdart/rxdart.dart';
import 'dart:async';

class SignInBloc {
  final _errorHandler = BehaviorSubject<String>();

  //streams
  Stream<String> get errorString => _errorHandler.stream;

  //sinks
  Function(String) get errorStringInput => _errorHandler.sink.add;

  dispose() {
    _errorHandler.close();
  }
}