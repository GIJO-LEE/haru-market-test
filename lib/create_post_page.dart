import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 판매상품 상세 생성 페이지
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  static const String routeName = "/create_post_page";

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String job = ''; // 하고 싶은 일
  String? error; // 경고 메세지

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("판매 글쓰기"),
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(Icons.close_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 글 제목 입력
            TextField(
              onChanged: (v) {
                // 텍스트 변경시 호출되는 함수
                job = v;
              },
              autofocus: true,
              decoration: InputDecoration(
                hintText: "글 제목",
                errorText: error,
              ),
            ),
            // 내용 입력
            TextField(
              onChanged: (v) {
                // 텍스트 변경시 호출되는 함수
                job = v;
              },
              autofocus: true,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "게시글 내용을 작성해주세요.\n(가품 및 판매 금지 물품은 게시가 제한될 수 있어요.)",
                errorText: error,
              ),
            ),
            // SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Color(0xFF2980b9),
          onPressed: () {
            // 추가하기 버튼 클릭시
            if (job.isEmpty) {
              setState(() {
                error = "내용을 입력해주세요."; // 내용이 없는 경우 에러 메세지
              });
            } else {
              setState(() {
                error = null; // 내용이 있는 경우 에러 메세지 숨기기
              });
              Navigator.pop(context, job); // job 변수를 반환하며 화면을 종료합니다.
            }
          },
          elevation: 0,
          label: Text(
            "완료",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
