import 'package:a4s/data/view/user_view_model.dart';
import 'package:a4s/myPage/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class SleepInfo extends ConsumerStatefulWidget {
  const SleepInfo({super.key});

  @override
  _SleepInfo createState() => _SleepInfo();
}

// 달력 marker event
class Event {
  String title;
  Event(this.title);
}

// class PositionData {
//   const PositionData(
//     this.position,
//     this.bufferedPosition,
//     this.duration
//   );
//
//   final Duration position;
//   final Duration bufferedPosition;
//   final Duration duration;
// }


class _SleepInfo extends ConsumerState<SleepInfo> {
  int pageNum = 2;
  void getPageNum(int index) {
    setState(() {
      pageNum = index;
    });
  }

  // 달력 기능 변수들
  DateTime _now = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay = DateTime.now();
  List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];

  List<String> _selectedImages = [];
  String _selectedImage = "";

  // 달력 format 상태 저장할 변수
  CalendarFormat format = CalendarFormat.month;

  dynamic itemList = [
    {
      "image" : "assets/result/231015_sleepstage_hypnogram.png",
      "date" : "2023-09-10",
    },
    {
      "image" : "assets/result/231016_sleepstage_hypnogram.png",
      "date" : "2023-10-01",
    }
  ];

  // 달력 이벤트

  Map<DateTime, List<Event>> events = {
    DateTime.utc(2023,9,10) : [ Event('title'), Event('title2') ],
    DateTime.utc(2023,10,1) : [ Event('title3') ],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }


  String _getImageForSelectedDate(DateTime selectedDate) {
    final formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    final matchingItems = itemList.where((item) => item['date'] == formattedDate).toList();
    if (matchingItems.isNotEmpty) {
      return matchingItems[0]['image'];
    } else {
      return "";
    }
  }

  List<String> _getImagesForSelectedDate(DateTime selectedDate) {
    final formattedDate = selectedDate.toString().split(" ")[0];
    final matchingItems = itemList.where((item) => item['date'] == formattedDate).toList();
    if (matchingItems.isNotEmpty) {
      return matchingItems.map<String>((item) => item['image'] as String).toList();
    } else {
      return [];
    }
  }


  // 토근 버튼 변수들
  String result = '';
  bool isVisual = true;
  bool isRecord = false;
  late List<bool> isSelected;

  // 녹음 기능 변수들
  String viewTxt = "";
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  bool isPlaying = false;
  String audioPath = '';

  Duration _duration = Duration();
  Duration _position = Duration();

  bool check = false;
  bool playCheck = false;

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    isSelected = [isVisual, isRecord];

    audioPlayer = AudioPlayer();
    audioRecord = Record();

    super.initState();
  }

  @override
  void dispose(){
    audioPlayer.dispose();
    audioRecord.dispose();

    super.dispose();
  }

  // 녹음 기닁 함수들
  Future<void> startRecording() async {  // 녹음 시작
    try{
      if (await audioRecord.hasPermission()){
        viewTxt = '녹음 중';

        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch(e){
      print('Error Start Recording: $e');
    }
  }

  Future<void> stopRecording() async {  // 녹음 중단
    try{
      String? path = await audioRecord.stop();
      setState(() {
        viewTxt = '';
        isRecording = false;
        audioPath = path!;
      });

    } catch(e){
      print('Error Start Recording: $e');
    }
  }

  Future<void> playRecording() async {  // 파일 재생
    try{
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
      setState(() {
        isPlaying = true;
      });

    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("녹음된 파일이 존재하지 않습니다."),
            )
        );
      print('Error Start Recording: $e');
    }
  }

  Future<void> stopplayRecording() async {  // 파일 중지
    try{
      setState(() {
        isPlaying = false;
      });
      await audioPlayer.stop();
    } catch(e){
      print('Error Start Recording: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: _key,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    // 달력
                    child: TableCalendar(
                      locale: 'ko_KR',
                      firstDay: DateTime.utc(2022, 9, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _now,
                      calendarFormat: format,
                      // 포맷 변경
                      onFormatChanged: (CalendarFormat format) {
                        setState(() {
                          this.format = format;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        markerSize: 10.0,
                        markerDecoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle
                        ),

                        // tableBorder: const TableBorder(
                        //   // top : BorderSide(color: Colors.grey),
                        //   // right : BorderSide(color: Colors.grey),
                        //   bottom : BorderSide(color: Colors.grey),
                        //   // left : BorderSide(color: Colors.grey),
                        // ),
                      ),
                      eventLoader: _getEventsForDay,

                      // 누른 날짜 맞는지 확인
                     selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },

                      // 지금 누른 날짜 표시
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          // Call `setState()` when updating the selected day
                          setState(() {
                            _selectedDay = selectedDay;
                            _now = focusedDay;
                            _selectedImage = _getImageForSelectedDate(selectedDay);
                          });
                        }
                      },

                      onPageChanged: (focusedDay) {
                        setState(() {
                          if(focusedDay.month == DateTime.now().month) {
                            _selectedDay = DateTime.now();
                            _now = DateTime.now();
                          } else {
                            _selectedDay = focusedDay;
                            _now = focusedDay;
                          }

                          _selectedImage = _getImageForSelectedDate(_selectedDay!);
                        });
                      },
                    ),
                  ),

                  // 버튼
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: ToggleButtons(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('수면', style: TextStyle(fontSize: 15))),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('녹음', style: TextStyle(fontSize: 15))),
                          ],
                          isSelected: isSelected,
                          onPressed: toggleSelect,
                        ),
                      ),
                      // 선택할때 다이어리 미리 보기 뜨는 곳.
                    if (isVisual == true)
                      if (_selectedImage.isNotEmpty)
                        Column(
                          children: [
                            Image.asset('assets/result/231016_sleepstage_hypnogram.png',
                              width: 400,
                              height: 200,),
                            Container(
                                margin: EdgeInsets.only(top: 15, left: 15, bottom: 25),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('수면 단계', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                      Text('R (REM): 렘 수면 / 꿈 수면', style: TextStyle(fontSize: 18),),
                                      Text('Deep Sleep: 깊은 수면', style: TextStyle(fontSize: 18),),
                                      Text('Ligth Sleep: 얕은 수면', style: TextStyle(fontSize: 18),),
                                      Text('W (Wake): 깨어있는 상태', style: TextStyle(fontSize: 18),)
                                    ],
                                  )
                              )
                            ),
                        ],
                        )
                      else
                        Text('내역이 존재하지 않습니다.')

                    else
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(20.0),
                              child: FloatingActionButton(
                                backgroundColor: Colors.blueAccent,
                                onPressed: isRecording ? stopRecording : startRecording,
                                tooltip: 'Increment',
                                child: Icon(
                                    isRecording ? Icons.stop : Icons.play_arrow,
                                color: Colors.white),
                              ),
                            ),
                            if (isRecording)
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 10), // 위쪽 여백
                                child: Text(
                                  viewTxt,
                                  style: Theme.of(context).textTheme.headline6,),
                              ),
                            Container(
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2.0, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text('${DateFormat('y-MM-dd').format(_now)}'),
                                  IconButton(
                                    icon: isPlaying ? Icon(Icons.stop) : Icon(Icons.play_circle_filled),
                                    onPressed: isPlaying? stopplayRecording : playRecording
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      )

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      isVisual = true;
      isRecord = false;
    } else {
      isVisual = false;
      isRecord = true;
    }
    setState(() {
      isSelected = [isVisual, isRecord];
    });
  }
}


