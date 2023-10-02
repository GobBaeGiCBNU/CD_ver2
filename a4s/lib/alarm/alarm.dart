import 'package:a4s/alarm/data.dart';
import 'package:a4s/notification.dart';
import 'package:a4s/theme_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';


class AlarmPage extends ConsumerStatefulWidget {
  const AlarmPage({super.key});

  @override
  _AlarmPage createState() => _AlarmPage();
}

class _AlarmPage extends ConsumerState<AlarmPage> {
  int pageNum = 1;
  void getPageNum(int index) {
    setState(() {
      pageNum = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   'Alarm',
          //   style: TextStyle(
          //     fontWeight: FontWeight.w700,
          //     fontSize: 24),
          // ),
          Expanded(
            child: ListView(
              children: alarms.map<Widget>((alarm) {
                // 알람 모양
                return Container(
                  // 알람끼리 간격
                  margin: const EdgeInsets.only(bottom: 32),
                  // box 내부 글씨 padding
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  // box 꾸미기
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: alarm.gradientColors,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black12.withOpacity(0.8),
                    //     blurRadius: 10,
                    //     spreadRadius: -8,
                    //     offset: Offset(1, 1)
                    //   )
                    // ],
                    borderRadius: BorderRadius.all(Radius.circular((24)))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // 알람 정보 & 활성화 바
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.label,
                              color: Colors.white,
                              size: 24,
                              ),
                            SizedBox(width: 8),
                            Text('Office', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Switch(
                          onChanged: (bool value){},
                          value: true,
                          activeColor: Colors.white,
                        ),
                        ]
                      ),
                      // 요일
                      Text('Mon-Fri', style: TextStyle(color: Colors.white)),
                      // 시간 설정
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('07: 00 AM',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700
                              )),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 36,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }).followedBy([
                // 알람 추가
                DottedBorder(
                  strokeWidth: 3,
                  color: Colors.black12,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(24),
                  dashPattern: [5, 4],
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: TextButton(
                      onPressed: () => FlutterLocalNotification.showNotification(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/add_button.png'
                          ),
                          SizedBox(height: 8),
                          Text(
                            '알람 추가',
                            style: TextStyle(
                              color: CustomColors.a4s
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
