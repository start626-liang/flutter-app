import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';

class Like extends StatefulWidget {
  final bool likeDefault;

  Like(this.likeDefault);

  @override
  LikeState createState() => LikeState();
}

class LikeState extends State<Like> {
  bool _isLike;

  @override
  void initState() {
    super.initState();
    _isLike = widget.likeDefault;
  }

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
