import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostService extends ChangeNotifier {
  final postCollection = FirebaseFirestore.instance.collection('post');

  Future<QuerySnapshot> readAllPost() async {
    return postCollection.get();
  }

  Future<QuerySnapshot> read(String uid) async {
    // 내 bucketList 가져오기
    throw UnimplementedError(); // return 값 미구현 에러
  }

  void create(
    String uid,
    String location,
    String title,
    String description,
    DateTime currentTime,
    int durationDays,
    String manufacturingCompany,
    String series,
    String model,
  ) async {
    // auctionEndDatetime
    DateTime endTime = currentTime.add(Duration(days: durationDays));

    // bucket 만들기
    await postCollection.add({
      'registerUserId': uid, // 포스트 등록 유저
      'location': location,
      'articleTitle': title, // 제목
      'description': description, // 세부설명
      'auctionStartDatetime': currentTime,
      'auctionDuration': durationDays,
      'auctionEndDateTime': endTime,
      'auctionState': '판매중',
      'manufacturingCompany': manufacturingCompany,
      'series': series,
      'modelName': model,
    });
    notifyListeners(); // 화면 갱신
  }

  void update(String docId, bool isDone) async {
    // bucket isDone 업데이트
  }

  void delete(String docId) async {
    // bucket 삭제
  }
}
