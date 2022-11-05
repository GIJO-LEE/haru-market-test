import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haru_market/main_page.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  static const String routeName = "/post_detail_page";

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          },
        ),
      ),
      body: Center(
        child: Text('Detail Page'),
      ),
    );
  }
}
