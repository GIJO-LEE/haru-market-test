import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

import 'main_page.dart';

/// 버킷 클래스
class Post {
  String title; // 타이틀명
  String description; // 상품설명
  String location; // 판매자 위치
  String etc_desc; // 기타 설명들
  DateTime registerDatetime = DateTime.parse("2022-11-07 00:00:00"); //
  String image =
      "https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP848/iphone13-pro-max-colors-480_2x.png";

  Post(this.title, this.description, this.location, this.etc_desc); // 생성자
}

class Seller {
  String nickName;
  String profileImage;

  Seller(this.nickName, this.profileImage);
}

// 상품 상세 페이지
class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  static const String routeName = "/post_detail_page";

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final curr_time = DateTime.now();
  DateTime register_time = DateTime.parse("2022-11-07 00:00:00");

  // final diff_time = curr_time.difference(register_time);

  Post post = Post("10/20에 구매한 아이폰 13 Pro Max 팔아요", "상품상세설명1", "강남구 신사동", "삼성");
  Seller seller = Seller("스파르타", "https://i.ibb.co/CwzHq4z/trans-logo-512.png");

  // String register_date = DateFormat('yyyy.MM.dd').format(post.registerDatetime);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          },
        ),
        actions: [
          // 수정버튼 (수정 안 하기로 했었지 않나?)
          Icon(
            Icons.edit_note_outlined,
          ),
          // 삭제버튼
          Icon(
            Icons.delete_outlined,
          ),
        ],
      ),
      body: Column(
        children: [
          // 아이템 이미지 롤링
          AspectRatio(
            aspectRatio: 12 / 4,
            child: ItemImgaeViewWidget(),
          ),
          // 판매자 정보
          Card(
            child: ListTile(
              // 판매자 정보 : 프로필 사진
              leading: CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white,
                // Image를 원 안에 제대로 들어가게 하기 위해 Padding으로 Wrapping!! (Good)
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    seller.profileImage,
                    width: 62,
                  ),
                ),
              ),
              // 판매자 정보 : 닉네임
              title: Text(seller.nickName),
              // 판매 위치 정보
              subtitle: Text(post.location),
              // 판매 시작 날짜
              trailing: TimerBuilder.periodic(
                const Duration(seconds: 1),
                builder: (context) {
                  return Text(
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemImgaeViewWidget extends StatelessWidget {
  const ItemImgaeViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return PageView(
      scrollDirection: Axis.horizontal, // Axis.vertical
      controller: controller,
      children: <Widget>[
        Center(
          child: Image.network(
              "https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP848/iphone13-pro-max-colors-480_2x.png"),
        ),
        Center(
          child: Image.network(
              "https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP848/iphone13-pro-max-colors-480_2x.png"),
        ),
      ],
    );
  }
}
