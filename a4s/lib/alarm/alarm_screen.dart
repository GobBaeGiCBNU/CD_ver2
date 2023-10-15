import 'package:flutter/material.dart';
import 'package:a4s/model/alarm.dart';
import 'package:a4s/provider/alarm_state.dart';
import 'package:a4s/service/alarm_scheduler.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key, required this.alarm}) : super(key: key);

  final Alarm alarm;

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with WidgetsBindingObserver {
  Timer? _vibrationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Vibration.vibrate(duration: 60000); //1000 = 1초
    _vibrationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      Vibration.vibrate(duration: 1000); // 0.5초 동안 진동
    });
    // TODO: 음악 재생하기
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _dismissAlarm();
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _dismissAlarm() async {
    final alarmState = context.read<AlarmState>();
    final callbackAlarmId = alarmState.callbackAlarmId!;
    // 알람 콜백 ID는 `AlarmScheduler`에 의해 일(0), 월(1), 화(2), ... , 토요일(6) 만큼 더해져 있다.
    // 따라서 이를 7로 나눈 몫이 해당 요일을 나타낸다.
    final firedAlarmWeekday = callbackAlarmId % 7;
    final nextAlarmTime =
        widget.alarm.timeOfDay.toComingDateTimeAt(firedAlarmWeekday);

    await AlarmScheduler.reschedule(callbackAlarmId, nextAlarmTime);

    alarmState.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '알람',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
              child: Material(
                color: Color(0xff6499ff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: MaterialButton(
                  onPressed: () {
                    _dismissAlarm();
                    _vibrationTimer?.cancel();
                  },
                  child: const Text(
                    '중단',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  height: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
