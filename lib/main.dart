import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'post_service.dart';
import 'create_post_page.dart';
import 'initial_page.dart';
import 'post_detail_page.dart';
import 'login_page.dart';
import 'main_page.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp(); // firebase 앱 시작
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => PostService()),
      ],
      child: MyApp(),
    ),
  );
}

// Handshake error in client (OS Error: CERTIFICATE_VERIFY_FAILED: application verification failure(handshake.cc:393))
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
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
    // PostDetailPage.routeName: (context) => PostDetailPage(uid: '', postid: '',),
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
