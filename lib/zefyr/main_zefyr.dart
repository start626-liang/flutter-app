// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_test_626/zefyr/src/form.dart';
import 'package:flutter_test_626/zefyr/src/full_page.dart';
import 'package:flutter_test_626/zefyr/src/view.dart';
import 'package:flutter_test_626/zefyr/src/editor_page.dart';

void main() {
  runApp(ZefyrApp());
}

class ZefyrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zefyr Editor',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: HomePage(),
      routes: {
        "/fullPage": buildFullPage,
        "/form": buildFormPage,
        "/view": buildViewPage,
        "/editor": buildEditorPage,
      },
    );
  }

  Widget buildEditorPage(BuildContext context) {
    return EditorPage();
  }

  Widget buildFullPage(BuildContext context) {
    return FullPageEditorScreen();
  }

  Widget buildFormPage(BuildContext context) {
    return FormEmbeddedScreen();
  }

  Widget buildViewPage(BuildContext context) {
    return ViewScreen();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.grey.shade200,
        brightness: Brightness.light,
        title: ZefyrLogo(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Container()),
          FlatButton(
            onPressed: () => nav.pushNamed('/fullPage'),
            child: Text('Full page editor'),
            color: Colors.lightBlue,
            textColor: Colors.white,
          ),
          FlatButton(
            onPressed: () => nav.pushNamed('/form'),
            child: Text('Embedded in a form'),
            color: Colors.lightBlue,
            textColor: Colors.white,
          ),
          FlatButton(
            onPressed: () => nav.pushNamed('/view'),
            child: Text('Read-only embeddable view'),
            color: Colors.lightBlue,
            textColor: Colors.white,
          ),
          FlatButton(
            onPressed: () => nav.pushNamed('/editor'),
            child: Text('Read8657ew'),
            color: Colors.lightBlue,
            textColor: Colors.white,
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
