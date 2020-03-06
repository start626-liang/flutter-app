import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';

class Trample extends StatefulWidget {
  final bool trampleDefault;

  Trample(this.trampleDefault);

  @override
  TrampleState createState() => TrampleState();
}

class TrampleState extends State<Trample> {
  bool _isTrample;

  @override
  void initState() {
    super.initState();
    _isTrample = widget.trampleDefault;
  }

  @override
  Widget build(BuildContext context) {
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
