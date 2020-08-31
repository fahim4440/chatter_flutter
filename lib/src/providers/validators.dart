import 'package:flutter/material.dart';

class Validation {
  String validateEmail(String value) {
    if (!(value.contains('@') && value.contains('.com'))) {
      return "Please enter valid email";
    }
  }

  String validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be atleast 6 characters";
    }
  }
  String validateName(String value) {
    if (value.length == 0) {
      return "Name can not be empty";
    } else if (value.contains('@') || value.contains('#') || value.contains('!') || value.contains('%') || value.contains('^') || value.contains('&') || value.contains('*') || value.contains('(') || value.contains(')')) {
      return "Name is invalid";
    }
  }
}