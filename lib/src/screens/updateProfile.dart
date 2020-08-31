import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import '../blocs/homeBlocProvider.dart';
import '../widgets/profilePicture.dart';
import '../widgets/circularProgressIndicator.dart';
import '../providers/repository.dart';
import '../providers/validators.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateProfileScreenState();
  }
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _repository = Repository();
  final _validators = Validation();
  final formKey = GlobalKey<FormState>();
  String updateName = '';
  File _image;
  final picker = ImagePicker();
  String uploadImageUrl;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = HomeBlocProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Update Profile'),
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
              GestureDetector(
                onTap: getImage,
                child: Center(
                  child: _image == null ?
                  ProfilePicture(width: 200.0, height: 200.0, photoUrl: snapshot.data[2], topMargin: 10.0,)
                      : Container(
                    width: 200.0,
                    height: 200.0,
                    margin: EdgeInsets.only(top: 10.0),
                    child: Image.file(_image),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  width: 250.0,
                  child: TextFormField(
                    validator: _validators.validateName,
                    onSaved: (String value) {
                      updateName = value.trim();
                    },
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      hintText: snapshot.data[0],
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueGrey
                          )
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueGrey
                          )
                      ),
                    ),
                    cursorColor: Colors.blueGrey,
                    cursorWidth: 5.0,
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
              submitButton(context, snapshot.data[1]),
            ],
          );
        },
      ),
    );
  }

  Widget submitButton(BuildContext context, String email) {
    return MaterialButton(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Container(
        height: 40.0,
        width: 170.0,
        child: Center(
          child: Text(
            'UPDATE',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
      onPressed: () async {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          await _repository.updateName(email, updateName);
          final String photoUrl = await _repository.uploadPhoto(_image, email);
          await _repository.updatePhoto(email, photoUrl);
          Navigator.pushReplacementNamed(context, '/profile');
        }
      },
    );
  }
}