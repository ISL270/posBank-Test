import 'dart:io';

import 'package:bawq_test/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bawq_test/utils/form_error.dart';
import 'package:bawq_test/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _userName;
  final List<String> _errors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                backgroundImage: image == null
                    ? const AssetImage('assets/images/placeHolder.jpg')
                    : FileImage(image!) as ImageProvider,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton.icon(
                    icon: const Icon(
                      Icons.collections,
                    ),
                    label: const Text('Pick from gallery'),
                    onPressed: () => userPic(ImageSource.gallery),
                  ),
                  TextButton.icon(
                    icon: const Icon(
                      Icons.photo_camera,
                    ),
                    label: const Text('Take a picture'),
                    onPressed: () => userPic(ImageSource.camera),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildFullNameFormField(),
                    const SizedBox(height: 30),
                    buildEmailFormField(),
                    const SizedBox(height: 30),
                    buildPasswordFormField(),
                    const SizedBox(height: 30),
                    buildConfirmPassFormField(),
                    const SizedBox(height: 15),
                    FormError(errors: _errors),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: onPressed,
                      child: const Text(
                        'SAVE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future userPic(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final tempImg = File(image.path);
      setState(() => this.image = tempImg);
    } on PlatformException {
      snackbarKey.currentState?.showSnackBar(const SnackBar(
        content: Text("Failed to pick image!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  void addError({required String error}) {
    if (!_errors.contains(error)) {
      setState(() {
        _errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (_errors.contains(error)) {
      setState(() {
        _errors.remove(error);
      });
    }
  }

  TextFormField buildFullNameFormField() {
    return TextFormField(
      onSaved: (newValue) => _userName = newValue,
      onChanged: (value) {
        if (value.isEmpty || nameValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidNameError);
        } else if (value.isNotEmpty) {
          removeError(error: NameNullError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: NameNullError);
          return "";
        } else if (!nameValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidNameError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Full Name",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => _email = newValue,
      onChanged: (value) {
        if (value.isEmpty || emailValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidEmailError);
        } else if (value.isNotEmpty) {
          removeError(error: EmailNullError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: EmailNullError);
          return "";
        } else if (value.isNotEmpty && !emailValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "E-mail",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => _password = newValue,
      onChanged: (value) {
        _password = value;
        if (value.length >= 8 || value.isEmpty) {
          removeError(error: ShortPassError);
        } else if (passwordValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidPassError);
        } else if (value.isNotEmpty) {
          removeError(error: PassNullError);
        } else if (_password == _confirmPassword) {
          removeError(error: MatchPassError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: PassNullError);
          return "";
        } else if (!passwordValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidPassError);
          return "";
        } else if (value.length < 8 && value.isNotEmpty) {
          addError(error: ShortPassError);
          return "";
        } else if (_password != value) {
          addError(error: MatchPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => _confirmPassword = newValue,
      onChanged: (value) {
        _confirmPassword = value;

        if (_password == _confirmPassword) {
          removeError(error: MatchPassError);
        }
      },
      validator: (value) {
        if (_password != value) {
          addError(error: MatchPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      ),
    );
  }

  void onPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (image != null) {
        snackbarKey.currentState?.showSnackBar(const SnackBar(
          content: Text("User added successfully!"),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      } else {
        snackbarKey.currentState?.showSnackBar(const SnackBar(
          content: Text("Please select image first!"),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      snackbarKey.currentState?.showSnackBar(const SnackBar(
        content: Text("Invalid input!"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
