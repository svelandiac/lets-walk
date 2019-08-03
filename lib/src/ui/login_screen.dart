import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginData {
  String email = '';
  String password = '';
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _LoginData _data = _LoginData();
  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    }

    return null;
  }

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      print('Printing the login data.');
      print('Email: ${_data.email}');
      print('Password: ${_data.password}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Center(
        child: Container(
          child: Form(
            key: this._formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Log in to your account",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress, // Use email input type for emails.
                        decoration: InputDecoration(
                          hintText: 'you@example.com',
                          labelText: 'E-mail Address'),
                        validator: this._validateEmail,
                        onSaved: (String value) {
                          this._data.email = value;
                        }),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Account password',
                            labelText: 'Password',
                          ),
                          validator: this._validatePassword,
                          onSaved: (String value) {
                            this._data.password = value;
                          },
                          obscureText: _obscureText,
                        ),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                icon: _obscureText
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: _toggle)),
                      ],
                    ),
                    Container(
                      width: screenSize.width,
                      child: RaisedButton(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: this.submit,
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: EdgeInsets.only(top: 20.0),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}