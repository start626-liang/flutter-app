import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../db/db.dart' as DB;
import '../db/essay-sql.dart' as EssaySql;
import '../db/essay-mode.dart';

class DraftsView extends StatefulWidget {
  DraftsView({Key key}) : super(key: key);

  @override
  DraftsViewState createState() {
    return DraftsViewState();
  }
}

class DraftsViewState extends State<DraftsView> {
  List<dynamic> _items = List<String>.generate(20, (i) => "Item ${i + 1}");
  // @override
  // void initState() async {
  //   super.initState();
  //   Database db;
  //   await DB.createDB().then((onValue) async {
  //     db = onValue;
  //     setState(() async {
  //       _items = await EssaySql.selectAll(db);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final title = 'Dismissing _items';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];

            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              // 每个Dismissible实例都必须包含一个Key。Key让Flutter能够对Widgets做唯一标识。
              key: Key(item),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              // 我们还需要提供一个函数，告诉应用，在项目被移出后，要做什么。
              onDismissed: (direction) {
                // Remove the item from the data source.
                // 从数据源中移除项目
                setState(() {
                  _items.removeAt(index);
                });

                // Then show a snackbar.
                // 展示一个 snackbar！
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$item dismissed")));
              },
              // Show a red background as the item is swiped away.
              // 列表项被滑出时，显示一个红色背景(Show a red background as the item is swiped away)
              background: Container(color: Colors.red),
              child: ListTile(title: Text('$item')),
            );
          },
        ),
      ),
    );
  }
}
