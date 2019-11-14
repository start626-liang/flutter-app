import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';

class Trample extends StatefulWidget {
  final bool _isTrample;

  Trample(this._isTrample);

  @override
  TrampleState createState() => TrampleState(this._isTrample);
}

class TrampleState extends State<Trample> {
  bool _isTrample;

  TrampleState(this._isTrample);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      icon: Icon(_isTrample
          ? CommunityMaterialIcons.thumb_up
          : CommunityMaterialIcons.thumb_up_outline),
      onPressed: () {
        setState(() {
          _isTrample = !_isTrample;
        });
      },
    );
  }
}
