import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../model/Store.dart';
import '../../redux/actions.dart';
import '../../model/User.dart';
import '../../http/sign-up-post.dart' as http;

// Create a Form widget.
class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() {
    return _SignUpFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _SignUpFormState extends State<SignUpForm> {
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

  Widget _buildAccountFormField() {
    return Container(
      child: TextFormField(
        controller: _account,
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
    );
  }

  Widget _buildPasswordFormField() {
    return Container(
      child: TextFormField(
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
      ),
    );
  }

  Widget _buildSignUp(OnStateUserGet callback) {
    return Center(
      child: Container(
        width: 320,
        child: FlatButton(
          color: Colors.red,
          onPressed: () async {
            // Validate returns true if the form is valid, or false
            // otherwise.
            if (_formKey.currentState.validate()) {
              _showDialog();

              try {
                final data = await http.signUpPost(
                    {'name': _account.text, 'password': _password.text});
                print(data);
                if (data['success']) {
//                  final User user = new User(name: _account.text, id: onValue['id']);
//                  callback(user);
                } else {
                      .showSnackBar(SnackBar(content: Text(data['msg'])));
                }
              } on Exception {
                print(2222222222);
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Error:unknown')));
              } finally {
                Navigator.of(context).pop();
              }

//              http.signUpPost({
//                'name': _account.text,
//                'password': _password.text
//              }).then((onValue) {
//                Navigator.of(context).pop();
//                print(onValue);
//                if (onValue['success']) {
//                  final User user = new User(name: _account.text, id: onValue['id']);
//                  callback(user);
//                  Navigator.pop(context);
//                } else {
//                  Scaffold.of(context)
//                      .showSnackBar(SnackBar(content: Text(onValue['msg'])));
//                }
//              }).catchError((onError) {
////
//              });



            } else {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('null')));
            }
          },
          child: Text('Sign up'),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      // 传入 context
      context: context,
      barrierDismissible: false,
      // 构建 Dialog 的视图
      builder: (_) => Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
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
            _buildAccountFormField(),
            _buildPasswordFormField(),
            _buildSignUp(callback),
          ],
        ),
      );
    });
  }
}

typedef OnStateUserGet = Function(User user);
