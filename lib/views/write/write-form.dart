import 'package:flutter/material.dart';

class WriteForm extends StatefulWidget {
  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<WriteForm> {
  final _formKey = GlobalKey<FormState>();
  final _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
          ],
        ),
      ),
    );
  }
}

//提交表单
//Padding(
//padding: const EdgeInsets.symmetric(vertical: 16.0),
//child: RaisedButton(
//onPressed: () {
//// Validate returns true if the form is valid, or false
//// otherwise.
//if (_formKey.currentState.validate()) {
//// If the form is valid, display a Snackbar.
//Scaffold.of(context).showSnackBar(
//SnackBar(content: Text('Processing Data')));
//}
//},
//child: Text('Submit'),
//),
//),

//  右下角按钮
//      floatingActionButton: Column(
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          FloatingActionButton(
//            onPressed: () {
//              _onImageButtonPressed(ImageSource.gallery);
//            },
//            heroTag: 'image0',
//            tooltip: 'Pick Image from gallery',
//            child: const Icon(Icons.photo_library),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(top: 16.0),
//            child: FloatingActionButton(
//              onPressed: () {
//                _onImageButtonPressed(ImageSource.camera);
//              },
//              heroTag: 'image1',
//              tooltip: 'Take a Photo',
//              child: const Icon(Icons.camera_alt),
//            ),
//          ),
//        ],
//      ),
