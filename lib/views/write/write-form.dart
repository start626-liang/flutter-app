import 'package:flutter/material.dart';

class WriteForm extends StatefulWidget {
  @override
  _WriteState createState() => _WriteState();
  final GlobalKey<FormState> formKey;
  WriteForm({
    @required this.formKey,
  });
}

class _WriteState extends State<WriteForm> {
  final _content = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
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
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
