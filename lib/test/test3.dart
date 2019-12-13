import 'dart:math';

import 'package:flutter/material.dart';

class Test3 extends StatefulWidget {
  var i = 11113111;
  @override
  T createState() {
    // TODO: implement createState
    return T();
  }
}

class T extends State<Test3> {
  a() {
    setState(() {
      widget.i = Random().nextInt(1000);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: A(widget.i, a),
    );
  }
}

class A extends StatefulWidget {
  var i;
  Function i1;
  A(this.i, this.i1);

  @override
  AA createState() {
    // TODO: implement createState
    return AA();
  }
}

class AA extends State<A> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return B(widget.i, widget.i1);
  }
}

class B extends StatelessWidget {
  final iii;
  final iiii;

  B(this.iii, this.iiii);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: iiii,
      child: ListView(
        children: <Widget>[
          Text('=================${iii.toString()}'),
          Text('=================${iii.toString()}'),
          Text('=================${iii.toString()}'),
          Text('=================${iii.toString()}'),
          Text('=================${iii.toString()}'),
        ],
      ),
    );
  }
}
