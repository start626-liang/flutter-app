import 'package:flutter/material.dart';

import './dialog.dart';

_showDialog(context) async {
  await showDialog(
    context: context,
    builder: (ctx) {
      return Center(
        child: MyDualog(),
      );
    },
  );
}

class WriteView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WriteState();
}

class _WriteState extends State<WriteView> {
  final _formKey = GlobalKey<FormState>();
  final _content = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _content,
                  autofocus: true,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "please enter",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () {
                    _showDialog(context);
                  },
                  child: Container(
                    // red box
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[500],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    width: 100,
                    height: 120,
                  ),
                ),
//                Padding(
//                  padding: const EdgeInsets.symmetric(vertical: 16.0),
//                  child: RaisedButton(
//                    onPressed: () {
//                      // Validate returns true if the form is valid, or false
//                      // otherwise.
//                      if (_formKey.currentState.validate()) {
//                        // If the form is valid, display a Snackbar.
//                        Scaffold.of(context).showSnackBar(
//                            SnackBar(content: Text('Processing Data')));
//                      }
//                    },
//                    child: Text('Submit'),
//                  ),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
