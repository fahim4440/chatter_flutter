import 'package:flutter/material.dart';
import '../blocs/homeBlocProvider.dart';

class Refresh extends StatelessWidget {

  final Widget child;

  Refresh({this.child});

  @override
  Widget build(BuildContext context) {
    final bloc = HomeBlocProvider.of(context);
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.fetchChatRooms();
      }
    );
  }
  
}