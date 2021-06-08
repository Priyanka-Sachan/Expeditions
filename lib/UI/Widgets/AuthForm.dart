import 'dart:io';

import 'package:expeditions/UI/Widgets/AuthImagePicker.dart';
import 'package:flutter/material.dart';

enum AuthMode { SignUp, SignIn }

class AuthForm extends StatefulWidget {
  final void Function(BuildContext context, String username, File image,
      String email, String password) signUp;
  final void Function(BuildContext context, String username, String password)
      signIn;

  AuthForm({required this.signUp, required this.signIn});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.SignIn;
  var _isLoading = false;

  String _username = '';
  String _email = '';
  String _password = '';
  File _image = File('');

  void _pickImage(File image) async {
    _image = image;
  }

  Future<void> _submit() async {
    if (_authMode == AuthMode.SignUp && _image.path.isEmpty)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a profile image.'),
      ));
    final isValid = _formKey.currentState!.validate();
    if (isValid) _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    try {
      if (_authMode == AuthMode.SignUp)
        widget.signUp(context, _username, _image, _email, _password);
      else
        widget.signIn(context, _email, _password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.SignIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.SignIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _authMode == AuthMode.SignUp
                    ? AuthImagePicker(pickImage: _pickImage)
                    : SizedBox(),
                _authMode == AuthMode.SignUp
                    ? TextFormField(
                        decoration: InputDecoration(labelText: 'Username'),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.trim().isEmpty)
                            return 'Please enter the username';
                          if (value.trim().length < 3)
                            return 'Username should be minimum 3 characters long.';
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!.trim();
                        },
                      )
                    : SizedBox(),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.trim().isEmpty)
                      return 'Please enter the email id.';
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!.trim();
                  },
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    validator: (value) {
                      if (value!.trim().isEmpty)
                        return 'Please enter the password.';
                      if (value.trim().length < 8)
                        return 'Password should be minimum 8 characters long.';
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!.trim();
                    }),
                SizedBox(
                  height: 8,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(
                      _authMode == AuthMode.SignIn ? 'LOGIN' : 'SIGN UP',
                    ),
                    onPressed: _submit,
                  ),
                OutlinedButton(
                  child: Text(
                    '${_authMode == AuthMode.SignIn ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  ),
                  onPressed: _switchAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
