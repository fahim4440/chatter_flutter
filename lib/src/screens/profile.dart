import 'package:flutter/material.dart';
import '../blocs/homeBlocProvider.dart';
import '../widgets/profilePicture.dart';
import '../widgets/circularProgressIndicator.dart';
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = HomeBlocProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder(
        stream: bloc.user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgress();
          }
          return Column(
            children: <Widget>[
              Center(
                child: ProfilePicture(width: 200.0, height: 200.0, photoUrl: snapshot.data[2], topMargin: 10.0,)
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Name: ${snapshot.data[0]}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Email: ${snapshot.data[1]}',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              MaterialButton(
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Container(
                  height: 40.0,
                  width: 170.0,
                  child: Center(
                    child: Text(
                      'EDIT',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, '/updateProfile');
                },
              ),
            ],
          );
        },
      ),
    );
  }
  
}