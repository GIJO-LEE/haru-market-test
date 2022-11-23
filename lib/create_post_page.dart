import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'create_post_util_page.dart';

// durations that can be selected
enum DurationString { oneDay, twoDays, threeDays }

/// 판매등록 페이지
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  static const String routeName = "/create_post_page";

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // 빈 칸 에러 관련 변수 정의
  String _titleJob = '';
  String? _titleError;
  String _descriptionJob = '';
  String? _descriptionError;

  // TextEditingController
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Duration 초기화
  DurationString? _selectedDuration = DurationString.oneDay;
  int durationDays = 1;

  //
  String location = '';
  String manufacturingCompany = '';
  String series = '';
  String model = '';

  @override
  Widget build(BuildContext context) {
    // 굳이 BucketService 새로고침과 상관 없으므로 Consumer 위에 작성
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!; // 반드시 로그인 후, 해당 페이지로 오므로 ! 붙임

    return Consumer<PostService>(
      builder: (context, bucketService, child) {
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
                // 판매 위치
                ListTile(
                  leading: Text('판매 위치'),
                  title: Text(
                    location,
                    textAlign: TextAlign.end,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.chevron_right_outlined,
                    ),
                    onPressed: () async {
                      String _location = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LocationPage()),
                      );
                      if (_location != null) {
                        setState(() {
                          location = _location;
                        });
                      }
                    },
                  ),
                ),
                // 제조사
                ListTile(
                  leading: Text('제조사'),
                  title: Text(
                    manufacturingCompany,
                    textAlign: TextAlign.end,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.chevron_right_outlined,
                    ),
                    onPressed: () async {
                      String? _manufacturingCompany = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ManufacturingCompanyPage()),
                      );
                      if ((_manufacturingCompany != null) &
                          (manufacturingCompany != _manufacturingCompany)) {
                        print(_manufacturingCompany);
                        print(_manufacturingCompany == null);
                        setState(() {
                          manufacturingCompany = _manufacturingCompany!;
                          series = '';
                          model = '';
                        });
                      }
                    },
                  ),
                ),
                // 시리즈
                ListTile(
                  leading: Text('시리즈'),
                  title: Text(
                    series,
                    textAlign: TextAlign.end,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.chevron_right_outlined,
                    ),
                    onPressed: () async {
                      if (manufacturingCompany == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("제조사를 먼저 선택해주세요."),
                        ));
                      } else {
                        String? _series = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SeriesPage(company: manufacturingCompany)),
                        );
                        if ((_series != null) & (series != _series)) {
                          setState(() {
                            series = _series!;
                            model = '';
                          });
                        }
                      }
                    },
                  ),
                ),
                // 모델명
                ListTile(
                  leading: Text('모델명'),
                  title: Text(
                    model,
                    textAlign: TextAlign.end,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.chevron_right_outlined,
                    ),
                    onPressed: () async {
                      if (manufacturingCompany == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("제조사를 선택해주세요."),
                        ));
                      } else if (series == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("시리즈를 선택해주세요."),
                        ));
                      } else {
                        String? _model = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModelsPage(
                                  company: manufacturingCompany,
                                  series: series)),
                        );
                        if ((_model != null) & (model != _model)) {
                          setState(() {
                            model = _model!;
                          });
                        }
                      }
                    },
                  ),
                ),
                // 게시글 제목 입력
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "글 제목",
                    errorText: _titleError,
                  ),
                  // 텍스트필드의 입력된 텍스트의 변화가 발생할 때마다 호출
                  onChanged: (v) {
                    // 텍스트 변경시 호출되는 함수
                    _titleJob = v;
                  },
                  autofocus: false,
                ),
                // 게시글 설명 입력
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText:
                        "게시글 내용을 작성해주세요.\n(가품 및 판매 금지 물품은 게시가 제한될 수 있어요.)",
                    errorText: _descriptionError,
                  ),
                  // 텍스트필드의 입력된 텍스트의 변화가 발생할 때마다 호출
                  onChanged: (v) {
                    // 텍스트 변경시 호출되는 함수
                    _descriptionJob = v;
                  },
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
                ListTile(
                  leading: Text('경매 기간'),
                ),
                // Duration 버튼
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: const Text('1일'),
                        leading: Radio<DurationString>(
                          value: DurationString.oneDay,
                          groupValue: _selectedDuration,
                          onChanged: (DurationString? value) {
                            setState(() {
                              _selectedDuration = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('2일'),
                        leading: Radio<DurationString>(
                          value: DurationString.twoDays,
                          groupValue: _selectedDuration,
                          onChanged: (DurationString? value) {
                            setState(() {
                              _selectedDuration = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('3일'),
                        leading: Radio<DurationString>(
                          value: DurationString.threeDays,
                          groupValue: _selectedDuration,
                          onChanged: (DurationString? value) {
                            setState(() {
                              _selectedDuration = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // floating 버튼 (판매글 생성)
          floatingActionButton: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.black87,
              elevation: 0,
              label: Text(
                "판매글 생성",
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: () {
                // 추가하기 버튼 클릭시
                if (_titleJob.isEmpty) {
                  setState(() {
                    _titleError = _titleJob.isEmpty ? "제목을 입력해주세요." : "";
                  });
                } else if (_descriptionJob.isEmpty) {
                  setState(() {
                    _descriptionError =
                        _descriptionJob.isEmpty ? "설명을 입력해주세요." : "";
                  });
                } else if (location == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("판매 위치를 선택해주세요."),
                  ));
                } else if (manufacturingCompany == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("제aa조사를 선택해주세요."),
                  ));
                } else if (series == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("시리즈를 선택해주세요."),
                  ));
                } else if (model == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("모델명을 선택해주세요."),
                  ));
                } else {
                  /// 문제 없을 시 bucket 에 추가
                  // auctionStartDatetime
                  DateTime currentTime =
                      DateTime.now().toLocal(); // 'Asia/Seoul'
                  // auctionDuration
                  var stringToIntDurationMap = {
                    'DurationString.oneDay': 1,
                    'DurationString.twoDays': 2,
                    'DurationString.threeDays': 3
                  };
                  durationDays =
                      stringToIntDurationMap[_selectedDuration.toString()]!;

                  bucketService.create(
                    user.uid,
                    location,
                    _titleJob, // titleController.text,
                    _descriptionJob, // descriptionController.text,
                    currentTime,
                    durationDays,
                    manufacturingCompany,
                    series,
                    model,
                  );
                  // 페이지 이동
                  Navigator.pop(context);
                }
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
