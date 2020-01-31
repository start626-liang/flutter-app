import 'package:flutter/material.dart';

class AddJourneyPage extends StatefulWidget {

  final DateTime time;

  AddJourneyPage(this.time);

  @override
  _AddJourneyState createState() {
    return _AddJourneyState();
  }
}

class _AddJourneyState extends State<AddJourneyPage> {
  final _formKey = GlobalKey<FormState>();

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

  Padding buildPadding() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          // if (_formKey.currentState.validate()) {
          //   final User user = new User(_account.text);
          //   callback(user);
          //   Navigator.pop(context);
          // } else {
          //   Scaffold.of(context).showSnackBar(SnackBar(content: Text('?????')));
          // }
        },
        child: Text('Sign In'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildAccountFormField(),
          buildPasswordFormField(),
          buildPadding(),
        ],
      ),
    );
    ;
  }
}

typedef OnStateUserGet = Function();
