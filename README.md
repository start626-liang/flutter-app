http请求

  lib\http   http请求的封装
  lib\http\post.dart	post的初步封装
  lib\http\url.dart 	请求地址

离线功能

  草稿箱：数据保存在本地数据库sqlite中
  日历：增加行程，保存在本地数据库sqlite中

路由-导航

  lib\App.dart
底部导航栏配置

  lib\bottom_navigation_widget.dart

命名

  文件命名  中划线分割
  代码 驼峰式大小写

数据库

  数据库使用的是sqlite
  App会在首次调用数据库时初始化建表，如需新建表，要卸载app
