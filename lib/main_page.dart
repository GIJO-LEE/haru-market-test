import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haru_market/bucket_service.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'login_page.dart';
import 'post_detail_page.dart';
import 'create_post_page.dart';

/// 버킷 클래스
class Bucket {
  String title; // 타이틀명
  String location; // 판매자 위치
  String image =
      "https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP848/iphone13-pro-max-colors-480_2x.png";
  Bucket(this.title, this.location); // 생성자
}

/// 메인 페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = "/home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bucket> bucketList = [
    Bucket("10/20에 구매한 아이폰 13 Pro Max 팔아요", "강남구 신사동"),
    Bucket("아이폰 13 mini 팔아요", "강남구 삼성동")
  ]; // 전체 버킷리스트 목록

  final postCollection = PostService();

  // 삭제 확인 다이얼로그
  void showDeleteDialog(int index) {
    // 다이얼로그 보여주기
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("정말로 삭제하시겠습니까?"),
          actions: [
            // 취소 버튼
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("취소"),
            ),
            // 확인 버튼
            TextButton(
              onPressed: () {
                setState(() {
                  // index에 해당하는 항목 삭제
                  bucketList.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text(
                "확인",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostService>(
      builder: (context, postService, child) {
        return Scaffold(
          appBar: AppBar(
            leading: Text("신사동"),
            actions: [
              Icon(
                Icons.search_outlined,
              ),
              Icon(
                Icons.notifications_outlined,
              ),
              // 로그아웃 텍스트 버튼
              TextButton(
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  // 로그아웃
                  context.read<AuthService>().signOut();
                  // 로그아웃 시 로그인 페이지로 이동
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginPage.routeName,
                    (route) => false,
                  );
                },
              )
            ],
          ),
          body: bucketList.isEmpty
              ? Center(child: Text("판매 상품이 없습니다."))
              : Container(
                  child: FutureBuilder<QuerySnapshot>(
                      future: postCollection.readAllPost(),
                      builder: (context, snapshot) {
                        final docs = snapshot.data?.docs ?? [];
                        // docs[i].get('series')
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: ListTile(
                                  // 판매리스트 이미지
                                  leading: Image.network(
                                    "https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP848/iphone13-pro-max-colors-480_2x.png",
                                  ),
                                  // 판매리스트 제목
                                  title: Text(docs[index].get('articleTitle')),
                                  // 판매리스트 위치
                                  subtitle: Text(docs[index].get('location')),
                                  onTap: () {
                                    // 판매리스트 상세페이지로 이동
                                    Navigator.pushNamed(
                                        context, PostDetailPage.routeName);
                                  },
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(thickness: 1);
                          },
                        );
                      }),
                ),
          // 판매리스트 생성페이지로 이동
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              // + 버튼 클릭시 버킷 생성 페이지로 이동
              String? job = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreatePostPage()),
              );
            },
          ),
        );
      },
    );
  }
}


// ListView.builder(
//                   itemCount: bucketList.length, // bucketList 개수 만큼 보여주기
//                   itemBuilder: (context, index) {
//                     Bucket bucket =
//                         bucketList[index]; // index에 해당하는 bucket 가져오기
//                     return ListTile(
//                       // 판매리스트 이미지
//                       leading: Image.network(
//                         bucket.image,
//                       ),
//                       // 판매리스트 제목
//                       title: Text(bucket.title),
//                       // 판매리스트 위치
//                       subtitle: Text(bucket.location),
//                       onTap: () {
//                         // 판매리스트 상세페이지로 이동
//                         Navigator.pushNamed(context, PostDetailPage.routeName);
//                       },
//                     );
//                   },
//                 )