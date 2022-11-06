import 'package:flutter/material.dart';

import 'login_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  static const String routeName = "/";

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPage.routeName,
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

// class Second extends StatefulWidget {
//   const Second({super.key});

//   @override
//   State<Second> createState() => _SecondState();
// }

// class _SecondState extends State<Second> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HaruMarket2'),
//         centerTitle: true,
//         backgroundColor: Colors.red,
//       ),
//       body: Center(
//         child: Image(
//           image: NetworkImage(
//               'https://postfiles.pstatic.net/MjAyMjExMDFfMjg2/MDAxNjY3MzA2NzgwNDc0.mDOLiMwpAXPYnL_XSi5AiVye_8wQyqRSnUYjLg0fp3Ig.5mdQNudc_WQqg_CNsXMcXNaxRoMu7-tI9ye9DiUDv_Eg.JPEG.mp3pmania/%ED%95%98%EB%A3%A8%EB%A7%88%EC%BC%93_%EC%B2%AB_%ED%99%94%EB%A9%B4(%EC%83%98%ED%94%8C)_jpg_2022-11-01_211150.jpg?type=w580'),
//         ),
//       ),
//     );
//   }
// }
