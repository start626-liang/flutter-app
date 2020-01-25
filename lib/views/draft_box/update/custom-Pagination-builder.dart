import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CustomPaginationBuilder extends SwiperPlugin {
  final Key key;

  const CustomPaginationBuilder({this.key});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
//    ThemeData themeData = Theme.of(context);

    return new Align(
      alignment: Alignment.bottomCenter,
      child: new Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            "${config.activeIndex + 1}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 34,
              decoration: TextDecoration.none,
            ),
          ),
          new Text(
            " / ",
            style: TextStyle(
              color: Colors.red,
              fontSize: 38,
              decoration: TextDecoration.none,
            ),
          ),
          new Text(
            "${config.itemCount}",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 38,
              decoration: TextDecoration.none,
            ),
          )
        ],
      ),
    );
  }
}
