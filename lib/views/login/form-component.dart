import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_test_626/model/Store.dart';
import 'package:flutter_test_626/redux/actions.dart';
import 'package:flutter_test_626/model/User.dart';

// Create a Form widget.
class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

// Create a text controller and use it to retrieve the current value
  // of the TextField.
  final account = TextEditingController();
  final password = TextEditingController();
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
            TextFormField(
              controller: account,
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
            ),
            TextFormField(
              controller: password,
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    final User user = new User(account.text);
                    callback(user);
                    Navigator.pop(context);
                  } else {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('?????')));
                  }
                },
                child: Text('Sign In'),
              ),
            ),
          ],
        ),
      );
    });
    // Build a Form widget using the _formKey created above.
  }
}

typedef OnStateUserGet = Function(User user);
