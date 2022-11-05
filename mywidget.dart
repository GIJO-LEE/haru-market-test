import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Second extends StatefulWidget {
  const Second({super.key});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HaruMarket2'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Image(
          image: NetworkImage(
              'https://postfiles.pstatic.net/MjAyMjExMDFfMjg2/MDAxNjY3MzA2NzgwNDc0.mDOLiMwpAXPYnL_XSi5AiVye_8wQyqRSnUYjLg0fp3Ig.5mdQNudc_WQqg_CNsXMcXNaxRoMu7-tI9ye9DiUDv_Eg.JPEG.mp3pmania/%ED%95%98%EB%A3%A8%EB%A7%88%EC%BC%93_%EC%B2%AB_%ED%99%94%EB%A9%B4(%EC%83%98%ED%94%8C)_jpg_2022-11-01_211150.jpg?type=w580'),
        ),
      ),
    );
  }
}
