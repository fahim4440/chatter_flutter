import 'package:flutter/material.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/chatscreen.dart';
import 'screens/profile.dart';
import 'screens/updateProfile.dart';
import 'widgets/checkSignIn.dart';
import 'blocs/signInProvider.dart';
import 'blocs/searchBlocProvider.dart';
import 'blocs/homeBlocProvider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInProvider(
      child: HomeBlocProvider(
        child: SearchBlocProvider(
          child: MaterialApp(
            onGenerateRoute: routes,
          ),
        ),
      ),
    );
  }

  Route routes(RouteSettings setting) {
    if (setting.name == '/') {
      return MaterialPageRoute(builder: (context) {
        final bloc = HomeBlocProvider.of(context);
        bloc.fetchChatRooms();
        bloc.fetchisLoggedIn();
        return CheckSignIn();
      });
    } else if (setting.name == '/signin') {
      return MaterialPageRoute(builder: (contex) {
        return SignIn();
      });
    } else if (setting.name == '/signup') {
      return MaterialPageRoute(builder: (context) {
        return SignUp();
      });
    } else if (setting.name == '/profile') {
      return MaterialPageRoute(builder: (context) {
        final bloc = HomeBlocProvider.of(context);
        bloc.fetchUserFromSharedPrefs();
        return ProfileScreen();
      });
    } else if(setting.name == '/updateProfile') {
      return MaterialPageRoute(builder: (context) {
        final bloc = HomeBlocProvider.of(context);
        bloc.fetchUserFromSharedPrefs();
        return UpdateProfileScreen();
      });
    } else {
      final receiverName = setting.name.replaceFirst('/', '');
      return MaterialPageRoute(builder: (context) {
        return ChatScreen(receiverName: receiverName,);
      });
    }
  }
}
