import 'package:flutter/material.dart';

import './button-list.dart';

class WriteView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WriteState();
}

class _WriteState extends State<WriteView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            minLines: 3,
            maxLength: 3,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              // red box
              child: Icon(Icons.add),
              decoration: BoxDecoration(
//              color: Colors.red[400],
                  ),
              padding: EdgeInsets.all(16),
              width: 240, //max-width is 240
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

_showDialog(context) async {
  await showDialog(
    context: context,
    builder: (ctx) {
      return Center(
        child: ButtonList(),
      );
    },
  );
}

//_showDialog(context);
