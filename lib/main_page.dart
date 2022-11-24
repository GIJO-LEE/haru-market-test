import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haru_market/post_service.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'login_page.dart';
import 'post_detail_page.dart';
import 'create_post_page.dart';

/// 메인 페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = "/home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                // setState(() {
                //   // index에 해당하는 항목 삭제
                //   bucketList.removeAt(index);
                // });
                // Navigator.pop(context);
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
    // 굳이 BucketService 새로고침과 상관 없으므로 Consumer 위에 작성
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!; // 반드시 로그인 후, 해당 페이지로 오므로 ! 붙임
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
          body: Container(
            child: FutureBuilder<QuerySnapshot>(
                future: postCollection.readAllPost(),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs ?? [];
                  return docs.length == 0
                      ? Center(child: Text("구매 가능한 상품이 없습니다."))
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                      left: 20, top: 010, right: 0, bottom: 0),
                                  // 판매리스트 이미지
                                  // leading: Image.network(
                                  //   "https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP848/iphone13-pro-max-colors-480_2x.png",
                                  // ),
                                  leading: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    child: Image.network(
                                      "https://images.unsplash.com/photo-1616348436168-de43ad0db179?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2762&q=80",
                                      alignment: Alignment.center,
                                      height: 100,
                                    ),
                                  ),
                                  // 판매리스트 제목
                                  title: Text(docs[index].get('articleTitle'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  // 판매리스트 위치
                                  subtitle: Text(docs[index].get('location')),
                                  onTap: () {
                                    // 판매리스트 상세페이지로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PostDetailPage(
                                          uid: user.uid,
                                          postid: docs[index].reference.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              thickness: 1,
                            );
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