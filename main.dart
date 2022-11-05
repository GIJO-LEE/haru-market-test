import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('HaruMarket'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Image(
            image: NetworkImage(
                'https://postfiles.pstatic.net/MjAyMjExMDFfMjg2/MDAxNjY3MzA2NzgwNDc0.mDOLiMwpAXPYnL_XSi5AiVye_8wQyqRSnUYjLg0fp3Ig.5mdQNudc_WQqg_CNsXMcXNaxRoMu7-tI9ye9DiUDv_Eg.JPEG.mp3pmania/%ED%95%98%EB%A3%A8%EB%A7%88%EC%BC%93_%EC%B2%AB_%ED%99%94%EB%A9%B4(%EC%83%98%ED%94%8C)_jpg_2022-11-01_211150.jpg?type=w580'),
          ),
        ),
      ),
    );
  }
}
