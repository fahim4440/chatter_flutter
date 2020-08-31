import 'package:flutter/material.dart';
import 'searchUser.dart';
import '../blocs/homeBlocProvider.dart';
import '../providers/repository.dart';
import '../widgets/homeList.dart';
import 'profile.dart';
import '../widgets/refresh.dart';

class Home extends StatelessWidget {

  final _repository = Repository();

  @override
  Widget build(BuildContext context) {
    final bloc = HomeBlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              width: 60.0,
              height: 40.0,
              child: Image.asset('assets/images/logo1.png'),
            ),
            SizedBox(width: 5.0,),
            Text('Chatter'),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (String value) {
              _select(value, context, bloc);
            },
            itemBuilder: (context) {
              return {'Profile','Logout'}.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice)
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Refresh(
        child: HomeList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.message),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return SearchUser();
            }
          ));
        },
      ),
    );
  }
  void _select(String value, BuildContext context, HomeBloc bloc){
    switch(value){
      case 'Profile':
        bloc.fetchUserFromSharedPrefs();
        Navigator.pushNamed(context, '/profile');
        break;
      case 'Logout':
        _repository.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
        break;
    }
  }
}
