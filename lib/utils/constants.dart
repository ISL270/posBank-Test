import 'package:flutter/material.dart';

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passwordValidatorRegExp = RegExp(r"^(?=.*?[a-zA-Z])(?=.*?[0-9])");
final RegExp nameValidatorRegExp = RegExp(r"^[a-zA-Z\s]*$");

const String InvalidNameError = "Name must contain letters only";
const String NameNullError = "Please Enter your name";
const String EmailNullError = "Please Enter your email";
const String InvalidEmailError = "Please Enter a valid email";
const String PassNullError = "Please Enter your password";
const String InvalidPassError =
    "Password must contain both letters and numbers";
const String ShortPassError = "Password must contain at least 8 characters";
const String MatchPassError = "Passwords don't match";

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18.0),
    borderSide: const BorderSide(width: 3, color: Colors.grey),
    gapPadding: 10,
  );

  OutlineInputBorder outlineInputErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18.0),
    borderSide: const BorderSide(width: 3, color: Colors.red),
    gapPadding: 10,
  );
  return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
      errorStyle: const TextStyle(height: 0),
      errorBorder: outlineInputErrorBorder);
}
