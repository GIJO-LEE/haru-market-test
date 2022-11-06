import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_post_page.dart';
import 'initial_page.dart';
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
        initialRoute: InitialPage.routeName,
        // onGenerateRoute: generateRoute,
        routes: routes);
  }

  final routes = {
    InitialPage.routeName: (context) => InitialPage(),
    LoginPage.routeName: (context) => LoginPage(),
    HomePage.routeName: (context) => HomePage(),
    CreatePostPage.routeName: (context) => CreatePostPage(),
    PostDetailPage.routeName: (context) => PostDetailPage(),
  };

  // Route? generateRoute(RouteSettings routeSettings) {
  //   switch (routeSettings.name) {
  //     // PostDetailPage 로 이동 시, argument 전달
  //     case PostDetailPage.routeName:
  //       return MaterialPageRoute(
  //         builder: (context) {
  //           var map = routeSettings.arguments as Map<String, dynamic>;
  //           return PostDetailPage(
  //             input_bucket: map['input_bucket'] as Bucket,
  //           );
  //         },
  //         settings: routeSettings,
  //       );
  //     default:
  //       return null;
  //   }
  // }
}
