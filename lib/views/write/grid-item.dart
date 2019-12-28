import 'package:flutter/material.dart';
typedef ShowDialog = void Function();
typedef OnItemBuild = void Function(Size size);

typedef ResultCallBack = bool Function();

typedef OnActionFinished = int Function(
    List<int> indexes); // 进行数据清除工作，并返回当前list的length

typedef OnItemSelectedChanged = void Function(
    int index, bool isSelected); // 选中状态回调


class GridItem extends StatefulWidget {
  final int index;

  final Widget child;

  final OnItemSelectedChanged onItemSelectedChanged;

  final Function singleDeleteStart;
  final ResultCallBack singleDeleteCancle;

  final Animation<Offset> slideAnimation;

  final OnItemBuild onItemBuild;

  GridItem(
      {this.index,
      this.child,
      this.onItemSelectedChanged,
      this.singleDeleteStart,
      this.singleDeleteCancle,
      this.slideAnimation,
      this.onItemBuild});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> with TickerProviderStateMixin {
  Size _size;

  bool _isDragging = false; // 长按事件

  @override
  void initState() {
    super.initState();
    // 获取当前控件的size属性,当渲染完成之后，自动回调,无需unregist
    WidgetsBinding.instance.addPostFrameCallback(onAfterRender);
  }

  @override
  void didUpdateWidget(GridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 获取当前控件的size属性,当渲染完成之后，自动回调,无需unregist
    WidgetsBinding.instance.addPostFrameCallback(onAfterRender);
  }

  void onAfterRender(Duration timeStamp) {
    _size = context.size;
    widget.onItemBuild(_size);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: buildItem(context),
      // onTap: () {
      //   print('${widget.index}====-)))))))))))))');
      // },
    );
  }

  Widget buildItem(BuildContext context) {
    return LongPressDraggable<int>(
      data: widget.index,
      child: (_isDragging // 被长按的对象组件
          ? Material(
              color: Colors.transparent,
            )
          : buildItemChild()),
      feedback: StatefulBuilder(builder: (context, state) { // 鼠标拖动时，显示的组件
        return SizedBox.fromSize(
            size: _size,
            child: Transform(
              child: widget.child,
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(1.2),
            ));
      }),
      onDragStarted: () {   // 拖动开始回调   
        print('长按图片${widget.index}');
        setState(() {
          _isDragging = true;
          widget.singleDeleteStart();
        });
      },
      onDragEnd: (details) { // 拖动结束回调
        print('放下图片');
        if (widget.singleDeleteCancle()) {
          _isDragging = false;
        } else {
          setState(() {
            _isDragging = false;
          });
        }
      },
      onDraggableCanceled: (velocity, offset) { // 拖动取消回调
        setState(() {
          _isDragging = false;
          widget.singleDeleteCancle();
        });
      },
    );
  }

  // 若动画不为空，则添加动画控件
  Widget buildItemChild() {
    if (widget.slideAnimation != null) {
      return SlideTransition(
        position: widget.slideAnimation,
        child: widget.child,
      );
    }
    return widget.child;
  }
}
