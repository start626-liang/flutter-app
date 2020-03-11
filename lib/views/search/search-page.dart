import 'package:flutter/material.dart';
import 'package:extended_tabs/extended_tabs.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('search')),
      body: ListView(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildConstrainedBox(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 400,
            ),
            child: MyHomePage(),
          ),
        ],
      ),
    );
  }

  ConstrainedBox buildConstrainedBox() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 40,
      ),
      child: TextFormField(
        cursorWidth: 2,
        textInputAction: TextInputAction.search,
        controller: _searchController,
        autovalidate: true,
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
          hintText: '??????????',
          filled: true,
          suffixIcon: Icon(
            Icons.remove_red_eye,
            color: Colors.white,
          ),
          fillColor: Colors.red,
        ),
        onChanged: (val) {
          print(val);
        },
        onEditingComplete: () {
          print("点击了键盘上的动作按钮");
        },
        validator: (value) {
          if (value.isNotEmpty) {
            print('222222222222');
          }
          return null;
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController tabController;
  final List<Tab> tabList = [
    Tab(text: "部门反馈"),
    Tab(text: "学术交流"),
    Tab(text: "活动反馈")
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          labelColor: Colors.black,
          tabs: tabList,
          controller: tabController,
        ),
        Expanded(
          child: ExtendedTabBarView(
            children: <Widget>[
              Text("Tab000"),
              Text("Tab001"),
              Text("Tab002"),
            ],
            controller: tabController,
            linkWithAncestor: true,
            cacheExtent: 1,
          ),
        )
      ],
    );
  }
}
