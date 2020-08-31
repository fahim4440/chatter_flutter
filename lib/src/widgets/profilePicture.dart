import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final double width;
  final double height;
  final double topMargin;
  final String photoUrl;

  ProfilePicture({this.width, this.height, this.topMargin, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(top: topMargin),
        child: photoUrl == 'null' ?
        Icon(Icons.account_circle)
        : CircleAvatar(backgroundImage: NetworkImage(photoUrl),),
    );
  }
}