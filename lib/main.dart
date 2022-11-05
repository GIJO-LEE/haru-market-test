import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_post_page.dart';
import 'post_detail_page.dart';
import 'login_page.dart';
import 'main_page.dart';

void main() {
  // MyApp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key); //const 제외 (test/widget_test.dart)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'haru-market',
        initialRoute: LoginPage.routeName,
        routes: routes);
  }

  final routes = {
    LoginPage.routeName: (context) => LoginPage(),
    HomePage.routeName: (context) => HomePage(),
    CreatePostPage.routeName: (context) => CreatePostPage(),
    PostDetailPage.routeName: (context) => PostDetailPage(),
  };
}
