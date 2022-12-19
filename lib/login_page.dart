import 'dart:convert' show json;
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'
    as kakao_sdk_user;
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'main_page.dart';

// 로그인을  구현할  플랫폼 , 저장 변수
enum LoginPlatform {
  google,
  kakao,
  naver,
  apple,
  none, // logout
}

LoginPlatform _loginPlatform = LoginPlatform.none;

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps._googleUsercontent.com',
  scopes: <String>[
    'email',
    'profile',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = "/social_login";

  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void checkUserAndPushHomePage(User? user) {
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("로그인 성공"),
      ));
      // 로그인 성공시 HomePage로 이동
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (route) => false,
        // arguments: {"update": true}
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("로그인 실패"),
      ));
    }
  }

  Future<User?> signInWithGoogle() async {
    // 로그인 실패 시 처리할 코드 필요!!
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return (await _auth.signInWithCredential(credential)).user;
  }

  void onGoogleSignIn(BuildContext context) async {
    final User? user = await signInWithGoogle();
    checkUserAndPushHomePage(user);
  }

  void signInWithKakao() async {
    print("signInWithKakao function start!!");
    try {
      bool isInstalled = await kakao_sdk_user.isKakaoTalkInstalled();

      kakao_sdk_user.OAuthToken token = isInstalled
          ? await kakao_sdk_user.UserApi.instance.loginWithKakaoTalk()
          : await kakao_sdk_user.UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('social login'),
      ),
      body: Column(
        children: [
          // 구글 로그인
          ElevatedButton(
            onPressed: () {
              signInWithKakao();
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey.shade200,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset('assets/images/google.png',
                  //     fit: BoxFit.contain, width: 40.0, height: 40.0),
                  Text(
                    '카카오로 로그인',
                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          // 구글 로그인
          ElevatedButton(
            onPressed: () {
              onGoogleSignIn(context);
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey.shade200,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/google.png',
                      fit: BoxFit.contain, width: 40.0, height: 40.0),
                  Text(
                    '구글로 로그인',
                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   width: 200,
          //   height: 200,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       FirebaseAuth.instance.signOut();
          //       _googleSignIn.disconnect();
          //       print('sign out');
          //       final check_user = context.read<AuthService>().currentUser();
          //       print(check_user);
          //     },
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'logout',
          //           style: TextStyle(fontSize: 25.0, color: Colors.black),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
