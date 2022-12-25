import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  const PostDetailPage(
      {required String this.uid, required String this.postid, Key? key})
      : super(key: key);

  final String uid;
  final String postid;
  static const String routeName = "/post_detail_page";

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  DateTime register_time = DateTime.parse('2022-11-18 21:50:00');

  String calculateRemainTime(DateTime register_time) {
    Duration remain_time = register_time.difference(DateTime.now());
    int remain_days = remain_time.inDays;
    int remain_hours = remain_time.inHours;
    int remain_mins = remain_time.inMinutes;
    int remain_secs = remain_time.inSeconds;

    if (remain_days > 0) {
      return remain_days.toString() + '일 남음';
    } else if (remain_hours > 0) {
      return remain_hours.toString() + '시간 남음';
    } else if (remain_secs > 0) {
      return remain_mins.toString() +
          '분 ' +
          (remain_secs % 60).toString() +
          '초';
    }
    return "over time";
  }

  @override
  Widget build(BuildContext context) {
    // 인자 넘기고 Firebase에서 함수 내에서 읽히는 것까지 확인
    String uid = widget.uid;
    String postid = widget.postid;

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
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          FirebaseFirestore.instance.collection("post").doc(postid).get(),
          FirebaseFirestore.instance
              .collection("order")
              .where("postId", isEqualTo: postid)
              .get(),
          FirebaseFirestore.instance.collection("user").get(),
          FirebaseFirestore.instance
              .collection("user")
              .where("userId", isEqualTo: uid)
              .get(),
          // FirebaseFirestore.instance.collection("user").where("userId", isEqualTo: ).get(),
        ]),
        builder: (context, snapshot) {
          final post = snapshot.data?[0];
          final order = snapshot.data?[1];
          final users = snapshot.data?[2];
          final customer = snapshot.data?[3];
          // final seller = snapshot.data?[4];
          if (post == null) {
            return Text('no data');
          }
          final temp_img_uri = "https://i.ibb.co/CwzHq4z/trans-logo-512.png";

          print("post : ${post}");
          print("order : ${order}");
          print("users : ${users}");
          return SingleChildScrollView(
            child: Column(
              children: [
                ////// 아이템 이미지 롤링
                AspectRatio(
                  aspectRatio: 12 / 4,
                  child: ItemImgaeViewWidget(),
                ),
                ////// 판매자 정보
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
                          temp_img_uri,
                          width: 62,
                        ),
                      ),
                    ),
                    // 판매자 정보 : 닉네임
                    title: Text("닉네임 데터 가져오기"), // seller.get("nickName")
                    // 판매 위치 정보
                    subtitle: Text(post.get('location')),
                    // 판매 시작
                    trailing: TimerBuilder.periodic(
                      const Duration(seconds: 1),
                      builder: (context) {
                        // 함수 작성 후 return Text에 넣기!!
                        return Text(
                          calculateRemainTime(
                              post.get("auctionEndDateTime").toDate()),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ////// 판매상품정보
                // 제목
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    post.get('articleTitle'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 상세정보 텍스트
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    '상세정보',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 상세정보 데이터 테이블
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Table(
                    border: TableBorder.all(color: Colors.transparent),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(),
                      // FlexColumnWidth(), IntrinsicColumnWidth()
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text('제조사'),
                          ),
                          Text(post.get('manufacturingCompany'))
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text('시리즈'),
                          ),
                          Text(post.get('series'))
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text('모델명'),
                          ),
                          Text(post.get('modelName'))
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text('용량')),
                          Text('512GB(데이터X)')
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text('색상')),
                          Text('검정(데이터X)')
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      post.get('description'),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Divider(height: 10),
                // 입찰자 리스트 텍스트
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    '입찰자 리스트',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 입찰자 리스트 확인
                order.docs.length == 0
                    ? Center(child: Text("입찰자가 없습니다."))
                    : Container(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: order.docs.length,
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
                                      height: 50,
                                    ),
                                  ),
                                  // 판매리스트 제목
                                  title:
                                      Text(order.docs[index].get('orderUserId'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          )),
                                  // 판매리스트 위치
                                  subtitle: Text(order.docs[index]
                                      .get('orderPrice')
                                      .toString()),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              thickness: 1,
                            );
                          },
                        ),
                      ),
                // ////// 판매자 정보
                // Card(
                //   child: ListTile(
                //     // 판매자 정보 : 프로필 사진
                //     leading: CircleAvatar(
                //       radius: 36,
                //       backgroundColor: Colors.white,
                //       // Image를 원 안에 제대로 들어가게 하기 위해 Padding으로 Wrapping!! (Good)
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Image.network(
                //           temp_img_uri,
                //           width: 62,
                //         ),
                //       ),
                //     ),
                //     // 판매자 정보 : 닉네임
                //     title: Text(seller.nickName),
                //     // 판매 위치 정보
                //     subtitle: Text(post.get('location')),
                //     // 판매 시작
                //     trailing: TimerBuilder.periodic(
                //       const Duration(seconds: 1),
                //       builder: (context) {
                //         // 함수 작성 후 return Text에 넣기!!
                //         return Text(
                //           calculateRemainTime(register_time),
                //           style: const TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
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
