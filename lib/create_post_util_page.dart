import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> data_list = [
      '종로구',
      '중구',
      '용산구',
      '성동구',
      '광진구',
      '동대문구',
      '중랑구',
      '성북구',
      '강북구',
      '도봉구',
      '노원구',
      '은평구',
      '서대문구',
      '마포구',
      '양천구',
      '강서구',
      '구로구',
      '금천구',
      '영등포구',
      '동작구',
      '관악구',
      '서초구',
      '강남구',
      '송파구',
      '강동구'
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('거래할 위치를 선택해주세요'),
      ),
      body: Container(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: data_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 30,
                width: double.infinity,
                child: Theme(
                    data: ThemeData(
                      splashColor: Colors.black.withOpacity(.5),
                    ),
                    child: ListTile(
                      title: Text(data_list[index]),
                      onTap: () {
                        Navigator.pop(context, data_list[index]);
                      },
                    )),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(thickness: 1);
          },
        ),
      ),
    );
  }
}

class ManufacturingCompanyPage extends StatelessWidget {
  const ManufacturingCompanyPage({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> data_list = ['삼성전자', '애플', 'LG전자', '기타'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('제조사를 선택해주세요'),
      ),
      body: Container(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: data_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 30,
                width: double.infinity,
                child: Theme(
                    data: ThemeData(
                      splashColor: Colors.black.withOpacity(.5),
                    ),
                    child: ListTile(
                      title: Text(data_list[index]),
                      onTap: () {
                        Navigator.pop(context, data_list[index]);
                      },
                    )),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(thickness: 1);
          },
        ),
      ),
    );
  }
}

class SeriesPage extends StatelessWidget {
  SeriesPage({required String this.company, Key? key}) : super(key: key);

  final String company;
  final cellphoneCollection = CellPhoneService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시리즈를 선택해주세요'),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
            future: cellphoneCollection.readSeries(company),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              List<String> series_list = [];
              for (var i = 0; i < docs.length; i++) {
                series_list.add(docs[i].get('series'));
              }
              series_list = series_list.toSet().toList();
              return ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: series_list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Theme(
                          data: ThemeData(
                            splashColor: Colors.black.withOpacity(.5),
                          ),
                          child: ListTile(
                            title: Text(series_list[index]),
                            onTap: () {
                              Navigator.pop(context, series_list[index]);
                            },
                          )),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(thickness: 1);
                },
              );
            }),
      ),
    );
  }
}

class ModelsPage extends StatelessWidget {
  ModelsPage(
      {required String this.company, required String this.series, Key? key})
      : super(key: key);

  final String company;
  final String series;
  final cellphoneCollection = CellPhoneService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모델을 선택해주세요'),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
            future: cellphoneCollection.readModels(company, series),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              return ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final doc = docs[index];
                  String model = doc.get('model');
                  return Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Theme(
                          data: ThemeData(
                            splashColor: Colors.black.withOpacity(.5),
                          ),
                          child: ListTile(
                            title: Text(model),
                            onTap: () {
                              Navigator.pop(context, model);
                            },
                          )),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(thickness: 1);
                },
              );
            }),
      ),
    );
  }
}

class CellPhoneService extends ChangeNotifier {
  final cellphoneCollection =
      FirebaseFirestore.instance.collection('cellphone');

  Future<QuerySnapshot> readSeries(String company) async {
    // 내 bucketList 가져오기
    return cellphoneCollection.where('company', isEqualTo: company).get();
  }

  Future<QuerySnapshot> readModels(String company, String series) async {
    // 내 bucketList 가져오기
    return cellphoneCollection
        .where('company', isEqualTo: company)
        .where('series', isEqualTo: series)
        .get();
  }
}
