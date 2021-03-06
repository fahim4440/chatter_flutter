import 'package:Chatter/src/providers/repository.dart';
import 'package:flutter/material.dart';
import '../providers/repository.dart';
import '../providers/validators.dart';
import '../blocs/signInProvider.dart';
import '../providers/authExceptionHandler.dart';
import '../providers/authResultStatus.dart';

class SignIn extends StatelessWidget {
  final _repository = Repository();
  final validators = Validation();
  final formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    final bloc = SignInProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/logo1.png'),
                SizedBox(height: 10.0,),
                emailField(),
                SizedBox(height: 10.0,),
                passwordField(),
                SizedBox(height: 10.0,),
                submitButton(context),
                SizedBox(height: 5.0,),
                googleSignIn(context),
                extra(context),
              ],
            ),
          )
        ),
      )
    );
  }

  Widget emailField() {
    return TextFormField(
      validator: validators.validateEmail,
      onSaved: (String value) {
        email = value;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, color: Colors.blueGrey,),
        fillColor: Colors.white10,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        hintText: 'you@example.com',
        hintStyle: TextStyle(color: Colors.blueGrey),
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.blueGrey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey[400]
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey
          )
        ),
      ),
    );
  }

  Widget passwordField() {
    return TextFormField(
      validator: validators.validatePassword,
      onSaved: (String value) {
        password = value;
      },
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.blueGrey,),
        fillColor: Colors.white10,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.blueGrey),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blueGrey
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blueGrey
            )
        ),
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return MaterialButton(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      onPressed: () async {
        if (formkey.currentState.validate()) {
          formkey.currentState.save();
          final status = await _repository.signIn(email, password);
          if (status == AuthResultStatus.successful) {
            Navigator.pushReplacementNamed(context, '/');
          } else {
            final errorMsg = AuthExceptionHandler.generateExceptionMessage(
                status);
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                  '$errorMsg',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                content: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                elevation: 1.0,
                backgroundColor: Colors.blueGrey,
              ),
              barrierDismissible: true,
            );
          }
        }
      },
      child: Container(
          height: 40.0,
          width: 170.0,
          child: Center(
            child: Text(
              'SIGN IN',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
      )
    );
  }

  Widget googleSignIn(BuildContext context) {
    return MaterialButton(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      onPressed: () async {
        await _repository.signInWithGoogle();
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Container(
        height: 40.0,
        width: 170.0,
        child: Center(
          child: Text(
            'SIGN IN WITH GOOGLE',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      )
    );
  }

  Widget extra(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Not have an account?'),
          FlatButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
            child: Text('Sign up here.'),
          )
        ],
      ),
    );
  }
}
