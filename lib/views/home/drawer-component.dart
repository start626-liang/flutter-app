import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../model/Store.dart';
import '../../model/User.dart';
import '../../main.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Store, User>(
      converter: (store) => store.state.user,
      builder: (BuildContext context, User user) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: GestureDetector(
                  onTap: () {
                    if (user.name == notLogin) {
                      Navigator.pushNamed(context, '/sign-in');
                    }
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            //边框设置
                            decoration: new BoxDecoration(
                              //背景
                              color: Colors.white,
                              //设置四周圆角 角度
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              //设置四周边框
                              border:
                                  new Border.all(width: 2, color: Colors.white),
//                              image: DecorationImage(
//                                  image: new NetworkImage(user.name != notLogin
//                                      ? 'https://tse3-mm.cn.bing.net/th?id=OIP.dXCIsZadSAJ3uGlYfRljmgHaHa&w=204&h=196&c=7&o=5&pid=1.7'
//                                      : '')),
                            ),
                            child: Icon(Icons.account_circle,
                                color: Colors.black12, size: 60),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            user.name == notLogin ? '点击登录' : 'id: ${user.id}'),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('草稿箱'),
                onTap: () {
                  Navigator.pushNamed(context, '/draft_box/list');
                },
              ),
              ListTile(
                title: Text('日历'),
                onTap: () {
                  Navigator.pushNamed(context, '/calendar');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
