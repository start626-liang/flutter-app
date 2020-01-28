import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../model/Store.dart';
import '../../redux/actions.dart';
import '../../model/User.dart';

// Create a Form widget.
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

// Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _account = TextEditingController();
  final _password = TextEditingController();

  TextFormField buildAccountFormField() {
    return TextFormField(
      controller: _account,
      autofocus: true,
      decoration: InputDecoration(
          labelText: "Account",
          hintText: "User name",
          prefixIcon: Icon(Icons.person)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _password,
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Your login password",
          prefixIcon: Icon(Icons.lock)),
      obscureText: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Padding buildPadding(OnStateUserGet callback) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          // Validate returns true if the form is valid, or false
          // otherwise.
          if (_formKey.currentState.validate()) {
            final User user = new User(_account.text);
            callback(user);
            Navigator.pop(context);
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('?????')));
          }
        },
        child: Text('Sign In'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Store, OnStateUserGet>(converter: (store) {
      return (user) => store.dispatch(SetUser(user));
    }, builder: (BuildContext context, OnStateUserGet callback) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildAccountFormField(),
            buildPasswordFormField(),
            buildPadding(callback),
          ],
        ),
      );
    });
  }
}

typedef OnStateUserGet = Function(User user);
