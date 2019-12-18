import 'package:flutter/material.dart';

import 'custom-animate-grid.dart';

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

  bool _isDragging = false;

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
      child: (_isDragging
          ? Material(
              color: Colors.transparent,
            )
          : buildItemChild()),
      feedback: StatefulBuilder(builder: (context, state) {
        return SizedBox.fromSize(
            size: _size,
            child: Transform(
              child: widget.child,
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(1.2),
            ));
      }),
      onDragStarted: () {
        print('长按图片');
        setState(() {
          _isDragging = true;
          widget.singleDeleteStart();
        });
      },
      onDragEnd: (details) {
        print('放下图片');
        if (widget.singleDeleteCancle()) {
          _isDragging = false;
        } else {
          setState(() {
            _isDragging = false;
          });
        }
      },
      onDraggableCanceled: (velocity, offset) {
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
