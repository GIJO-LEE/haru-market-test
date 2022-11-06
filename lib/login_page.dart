import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

/// 설치 페이지

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = "/login_page";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 현재 유저 로그인 상태
            Center(
              child: Text(
                "로그인해 주세요 🙂",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 32),

            /// 이메일
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "이메일"),
            ),

            /// 비밀번호
            TextField(
              controller: passwordController,
              obscureText: false, // 비밀번호 안보이게
              decoration: InputDecoration(hintText: "비밀번호"),
            ),
            SizedBox(height: 32),

            /// 로그인 버튼
            ElevatedButton(
              child: Text("로그인", style: TextStyle(fontSize: 21)),
              onPressed: () {
                // 로그인 성공시 HomePage로 이동
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomePage.routeName,
                  (route) => false,
                  // arguments: {"update": true}
                );
              },
            ),

            /// 회원가입 버튼
            ElevatedButton(
              child: Text("회원가입", style: TextStyle(fontSize: 21)),
              onPressed: () {
                // 회원가입
                print("sign up");
              },
            ),
          ],
        ),
      ),
    );
  }
}
