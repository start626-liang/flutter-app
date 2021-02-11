import 'package:flutter/material.dart';
import 'package:extended_tabs/extended_tabs.dart';

class PageView extends StatefulWidget {
  @override
  _PageViewState createState() => _PageViewState();
}

class _PageViewState extends State<PageView> with TickerProviderStateMixin {
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
    final List<Widget> itemList = [];

    for (int i = 0; i < 25; i++) {
      itemList.add(Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            //背景装饰
            gradient: RadialGradient(
                //背景径向渐变
                colors: [Colors.red, Colors.orange],
                center: Alignment.topLeft,
                radius: .98),
          ),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                Icons.ac_unit,
                size: 30,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                i.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          )));
    }

    final List<Widget> pageList = [];

    for (int i = 0; i < tabList.length; i++) {
      pageList.add(ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 4.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start,
              children: itemList,
            ),
          ),
        ],
      ));
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 500,
      ),
      child: Column(
        children: <Widget>[
          TabBar(
            labelColor: Colors.black,
            tabs: tabList,
            controller: tabController,
          ),
          Expanded(
            child: ExtendedTabBarView(
              children: pageList,
              controller: tabController,
              // linkWithAncestor: true,
              cacheExtent: 1,
            ),
          )
        ],
      ),
    );
  }
}
