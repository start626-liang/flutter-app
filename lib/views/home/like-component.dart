import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';

class Like extends StatefulWidget {
  final bool _isLike;

  Like(this._isLike);

  @override
  LikeState createState() => LikeState(this._isLike);
}

class LikeState extends State<Like> {
  bool _isLike;

  LikeState(this._isLike);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isLike
          ? CommunityMaterialIcons.thumb_down
          : CommunityMaterialIcons.thumb_down_outline),
      onPressed: () {
        setState(() {
          _isLike = !_isLike;
        });
      },
    );
  }
}
