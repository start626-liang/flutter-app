import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../db/essay-mode.dart';
import '../../../db/db.dart' as DB;
import '../../../db/essay-sql.dart' as EssaySql;
import '../../../db/image-sql.dart' as ImageSql;
import '../update/update-view.dart';

class DraftsView extends StatefulWidget {
  DraftsView({Key key}) : super(key: key);

  @override
  DraftsViewState createState() {
    return DraftsViewState();
  }
}

class DraftsViewState extends State<DraftsView> {
  List<dynamic> _contentList;
  Future _future;
  Future<void> futureDB() async {
    Database db;
    await DB.createDB().then((onValue) async {
      db = onValue;
      List<Essay> list = await EssaySql.selectAll(db);
      setState(() {
        _contentList = list;
      });
      return;
    });
  }

  Widget buildDelectBackground() {
    return Container(
      color: Colors.red,
      child: ListTile(
        subtitle: Center(
          child: Text(
            '删除',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        trailing: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildDelectContent(item) {
    return ListTile(
        title: Text(item.text, softWrap: false),
        subtitle: Text(item.time, softWrap: false),
        onTap: () {
          print(item.id);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpdatePage(id: item.id)),
          );
        });
  }

  Widget buildItem(context, item, index) {
    return Dismissible(
      // 必须拖动项目的偏移阈值才能被视为已解除
      dismissThresholds: {DismissDirection.horizontal: 500},
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify widgets.
      // 每个Dismissible实例都必须包含一个Key。Key让Flutter能够对Widgets做唯一标识。
      key: Key(item.id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      // 我们还需要提供一个函数，告诉应用，在项目被移出后，要做什么。
      onDismissed: (direction) {
        // Remove the item from the data source.
        // 从数据源中移除项目
        setState(() {
          _contentList.removeAt(index);
        });
        // Then show a snackbar.
        // 展示一个 snackbar！
        Database db;
        DB.createDB().then((onValue) async {
          db = onValue;
          await EssaySql.deleteEssay(db, item.id);
          await ImageSql.deleteImageDirectory(db, item.directory);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("ok")));
        });
      },
      // 列表项被滑出时，显示一个背景(Show a red background as the item is swiped away)
      background: buildDelectBackground(),
      child: buildDelectContent(item),
    );
  }

  @override
  void initState() {
    super.initState();
    _future = futureDB();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Draft_Box';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: FutureBuilder<void>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('ConnectionState.none');
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                return ListView.builder(
                  itemCount: _contentList.length,
                  itemBuilder: (context, index) {
                    final Essay item = _contentList[index];
                    return buildItem(context, item, index);
                  },
                );
              default:
                return Text('?????');
            }
          },
        ),
        //  右下角按钮
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/draft_box/write');
          },
        ),
      ),
    );
  }
}
