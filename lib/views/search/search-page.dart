import 'package:flutter/material.dart';

import 'page-view.dart' as page;

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = new TextEditingController();

  bool _search = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('search')),
      body: ListView(
        children: <Widget>[
          buildConstrainedBox(),
          _search ? page.PageView() : buildSearchResult(context),
        ],
      ),
    );
  }

  Widget buildSearchResult(BuildContext context) {
    return Text('data');
  }

  ConstrainedBox buildConstrainedBox() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 40,
      ),
      child: TextField(
        cursorWidth: 2,
        textInputAction: TextInputAction.search,
        controller: _searchController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(top: 5),
          border: OutlineInputBorder(
            /*边角*/
            gapPadding: 0,
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(30), //边角为30
            ),
          ),
          prefixIcon: Icon(
            Icons.search,
//                  color: Colors.white,
          ),
          hintText: '请输入',
          filled: true,
          fillColor: Colors.red,
        ),
        onChanged: (val) {
          if (0 == val.length) {
            setState(() {
              _search = true;
            });
          } else {
            setState(() {
              _search = false;
            });
          }
        },
        onEditingComplete: () {
          print("点击了键盘上的动作按钮");
        },
      ),
    );
  }
}
