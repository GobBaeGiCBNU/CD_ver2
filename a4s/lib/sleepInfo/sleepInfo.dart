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

class Event {
  final DateTime date ;
  Event({required this.date});
}

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
  DateTime? _selectedDay;
  List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];

  // 달력 이벤트
  final _events = LinkedHashMap(
    equals: isSameDay,
  )..addAll({
    DateTime(2022, 8, 4) : Event(date: DateTime(2022, 8, 4)),
    DateTime(2022, 8, 6) : Event(date: DateTime(2022, 8, 6)),
    DateTime(2022, 8, 7) : Event(date: DateTime(2022, 8, 7)),
    DateTime(2022, 8, 9) : Event(date: DateTime(2022, 8, 9)),
    DateTime(2022, 8, 11) : Event(date: DateTime(2022, 8, 11)),
    DateTime(2022, 8, 14) : Event(date: DateTime(2022, 8, 14)),
  }) ;

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

  Future<void> startRecording() async {
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

  Future<void> stopRecording() async {
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

  Future<void> playRecording() async {
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

  Future<void> stopplayRecording() async {
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
                    // 달력
                    child: TableCalendar(
                      locale: 'ko_KR',
                      firstDay: DateTime.utc(2022, 9, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _now,

                      // 이벤트 처리 만들기
                      // selectedDayPredicate: (day) {
                      //   // Use `selectedDayPredicate` to determine which day is currently selected.
                      //   // If this returns true, then `day` will be marked as selected.
                      //
                      //   // Using `isSameDay` is recommended to disregard
                      //   // the time-part of compared DateTime objects.
                      //   return isSameDay(_selectedDay, day);
                      // },
                      // onDaySelected: (selectedDay, focusedDay) {
                      //   if (!isSameDay(_selectedDay, selectedDay)) {
                      //     // Call `setState()` when updating the selected day
                      //     setState(() {
                      //       _selectedDay = selectedDay;
                      //       _now = focusedDay;
                      //     });
                      //   }
                      // },
                      // onFormatChanged: (format) {
                      //   if (_calendarFormat != format) {
                      //     // Call `setState()` when updating calendar format
                      //     setState(() {
                      //       _calendarFormat = format;
                      //     });
                      //   }
                      // },
                      // onPageChanged: (focusedDay) {
                      //   // No need to call `setState()` here
                      //   _now = focusedDay;
                      // },
                      // calendarBuilders: CalendarBuilders(
                      //   dowBuilder: (context, day) {
                      //     return Center(child: Text(days[day.weekday])) ;
                      //   },
                      //   markerBuilder: (context, date, events) {
                      //     DateTime _date = DateTime(date.year, date.month, date.day);
                      //     if ( isSameDay(_date, _events[_date] )) {
                      //       return Container(
                      //         width: MediaQuery.of(context).size.width * 0.11,
                      //         padding: const EdgeInsets.only(bottom: 5),
                      //         decoration: const BoxDecoration(
                      //           color: Colors.lightBlue,
                      //           shape: BoxShape.circle,
                      //         ),
                      //       );
                      //     }
                      //   },
                      // ),
                    ),
                  ),

                  // 버튼
                  Column(
                    children: [
                      ToggleButtons(
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
                      if (isVisual == true)
                        Image.asset('assets/result/231015_sleepstage_hypnogram.png',
                          width: 400,
                          height: 200,)

                      else
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                viewTxt,
                                style: Theme.of(context).textTheme.headline4,
                              ),
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
                        ),
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

  // 녹음 기능 함수들
//   Future<void> _recodeFunc() async{
//     PermissionStatus status = await Permission.microphone.status;
//     if (status != PermissionStatus.granted) throw RecordingPermissionException("Microphone permission not granted");
//     setState(() {
//       viewTxt = "Recoding ~";
//       print("check 변수 값: $check");
//     });
//     if(!check){
//       Directory tempDir = await getTemporaryDirectory();
//       File outputFile = File('${tempDir.path}/flutter_sound-tmp.aacADTS');
//       await myRecorder?.startRecorder(toFile: outputFile.path,codec: Codec.aacADTS);
//       print("START");
//       setState(() {
//         check = !check;
//       });
//       return;
//     }
//
//     print("STOP");
//     setState(() {
//       check = !check;
//       viewTxt = "await...";
//     });
//     await myRecorder?.stopRecorder();
//     return;
//   }
//
//   Future<void> playMyFile() async{
//     if(!playCheck){
//       Directory tempDir = await getTemporaryDirectory();
//       File inFile = File('${tempDir.path}/flutter_sound-tmp.aacADTS');
//       try{
//         Uint8List dataBuffer = await inFile.readAsBytes();
//         print("dataBuffer $dataBuffer");
//         setState(() {
//           playCheck = !playCheck;
//         });
//         await this.myPlayer?.startPlayer(
//             fromDataBuffer: dataBuffer,
//             codec: Codec.aacADTS,
//             whenFinished: () {
//               print('Play finished');
//               setState(() {});
//             });
//       }
//       catch(e){
//         print(" NO Data");
//         // 기존 _key.currentState?
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("NO DATA!!!!!!"),
//             )
//         );
//       }
//       return;
//     }
//     await myPlayer?.stopPlayer();
//     setState(() {
//       playCheck = !playCheck;
//     });
//     print("PLAY STOP!!");
//     return;
//   }
//
// }

// class Calendar extends StatelessWidget {
  // Calendar({super.key});
  // @override
  // Widget build(BuildContext context) {
  //   return TableCalendar(
  //     locale: 'en_US',
  //     events: _selectedDay,
  //     initialCalendarFormat: CalendarFormat.month,
  //     formatAnimation: FormatAnimation.slide,
  //     startingDayOfWeek: StartingDayOfWeek.sunday,
  //     availableGestures: AvailableGestures.none,
  //     availableCalendarFormats: const {
  //       CalendarFormat.month: 'Month',
  //     },
  //     calendarStyle: CalendarStyle(
  //       weekdayStyle: TextStyle(color: Colors.white),
  //       weekendStyle: TextStyle(color: Colors.white),
  //       outsideStyle: TextStyle(color: Colors.grey),
  //       unavailableStyle: TextStyle(color: Colors.grey),
  //       outsideWeekendStyle: TextStyle(color: Colors.grey),
  //     ),
  //     daysOfWeekStyle: DaysOfWeekStyle(
  //       dowTextBuilder: (date, locale) {
  //         return DateFormat.E(locale)
  //             .format(date)
  //             .substring(0, 3)
  //             .toUpperCase();
  //       },
  //       weekdayStyle: TextStyle(color: Colors.grey),
  //       weekendStyle: TextStyle(color: Colors.grey),
  //     ),
  //     headerVisible: false,
  //     builders: CalendarBuilders(
  //       markersBuilder: (context, date, events, holidays) {
  //         return [
  //           Container(
  //             decoration: new BoxDecoration(
  //               color: Color(0xFF30A9B2),
  //               shape: BoxShape.circle,
  //             ),
  //             margin: const EdgeInsets.all(4.0),
  //             width: 4,
  //             height: 4,
  //           )
  //         ];
  //       },
  //       selectedDayBuilder: (context, date, _) {
  //         return Container(
  //           decoration: new BoxDecoration(
  //             color: Color(0xFF30A9B2),
  //             shape: BoxShape.circle,
  //           ),
  //           margin: const EdgeInsets.all(4.0),
  //           width: 100,
  //           height: 100,
  //           child: Center(
  //             child: Text(
  //               '${date.day}',
  //               style: TextStyle(
  //                 fontSize: 16.0,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ), firstDay: null, focusedDay: null, lastDay: null,
  //   );
  // }

  // final Map<DateTime, List> _selectedDay = {
  //   DateTime(2019, 4, 3): ['Selected Day in the calendar!'],
  //   DateTime(2019, 4, 5): ['Selected Day in the calendar!'],
  //   DateTime(2019, 4, 22): ['Selected Day in the calendar!'],
  //   DateTime(2019, 4, 24): ['Selected Day in the calendar!'],
  //   DateTime(2019, 4, 26): ['Selected Day in the calendar!'],
  // };
// }
