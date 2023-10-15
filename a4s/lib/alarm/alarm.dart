import 'package:a4s/notification.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/model/alarm.dart';
import 'package:a4s/provider/alarm_list_provider.dart';
import 'package:a4s/service/alarm_scheduler.dart';
import 'package:provider/provider.dart' as provider;
import '../main.dart';

void _createAlarm(
  BuildContext context,
  AlarmListProvider alarmListProvider,
) async {
  final time = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 8, minute: 30),
  );
  if (time == null) return;

  final alarm = Alarm(
    id: alarmListProvider.getAvailableAlarmId(),
    hour: time.hour,
    minute: time.minute,
    enabled: true,
  );

  alarmListProvider.add(alarm);
  await AlarmScheduler.scheduleRepeatable(alarm);
}

void _deleteAlarm(AlarmListProvider alarmListProvider, Alarm alarm) async {
  alarmListProvider.remove(alarm);
}

void _switchAlarm(
  AlarmListProvider alarmListProvider,
  Alarm alarm,
  bool enabled,
) async {
  final newAlarm = alarm.copyWith(enabled: enabled);
  alarmListProvider.replace(
    alarm,
    newAlarm,
  );
  if (enabled) {
    await AlarmScheduler.scheduleRepeatable(newAlarm);
  } else {
    await AlarmScheduler.cancelRepeatable(newAlarm);
  }
}

void _handleCardTap(
  AlarmListProvider alarmList,
  Alarm alarm,
  BuildContext context,
) async {
  final time = await showTimePicker(
    context: context,
    initialTime: alarm.timeOfDay,
  );
  if (time == null) return;

  final newAlarm = alarm.copyWith(hour: time.hour, minute: time.minute);

  alarmList.replace(alarm, newAlarm);
  if (alarm.enabled) await AlarmScheduler.cancelRepeatable(alarm);
  if (newAlarm.enabled) await AlarmScheduler.scheduleRepeatable(newAlarm);
}

// Future<String> _rangeAlarm(Alarm alarm) async {
//   var hour = alarm.timeOfDay.hour - 1;
//   var min = alarm.timeOfDay.minute;
//
//   String range = hour.toString() + ':' + min.toString();
//
//   return range;
// }

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          _createAlarm(context, context.read<AlarmListProvider>());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: provider.Consumer<AlarmListProvider>(
                  builder: (context, alarmList, child) => ListView.builder(
                    itemCount: alarmList.length,
                    itemBuilder: (context, index) {
                      final alarm = alarmList[index];
                      return _AlarmCard(
                        alarm: alarm,
                        onTapSwitch: (enabled) {
                          _switchAlarm(alarmList, alarm, enabled);
                        },
                        onTapCard: () {
                          _handleCardTap(alarmList, alarm, context);
                        },
                        onTapDelete: () {
                          _deleteAlarm(alarmList, alarm);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    Key? key,
    required this.alarm,
    required this.onTapSwitch,
    required this.onTapCard,
    required this.onTapDelete,
  }) : super(key: key);

  final Alarm alarm;
  final void Function(bool enabled) onTapSwitch;
  final VoidCallback onTapCard;
  final VoidCallback onTapDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: onTapCard,
        child: Container(
          // 알람끼리 간격
          // margin: const EdgeInsets.only(bottom: 20),
          // box 내부 글씨 padding
          // padding: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF856CFD).withOpacity(alarm.enabled ? 1.0 : 0.4),
                  Color(0xff66a3ff).withOpacity(alarm.enabled ? 1.0 : 0.4)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      alarm.timeOfDay.format(context),
                      style: theme.textTheme.headline6!.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(
                          alarm.enabled ? 1.0 : 0.4,
                        ),
                      ),
                    ),
                  ),
                  Switch(
                      value: alarm.enabled,
                      onChanged: onTapSwitch,
                      activeColor: Colors.white),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // 알람 시간 범위 보여줌
                  if (alarm.timeOfDay.hour - 1 < 0)
                    Text(
                      ('11:' + alarm.timeOfDay.minute.toString() + ' PM ~ ' +
                          alarm.timeOfDay.format(context)),
                      style: TextStyle(
                          color: Colors.white
                              .withOpacity(alarm.enabled ? 1.0 : 0.4),
                          fontSize: 15),
                    )
                  else if (alarm.timeOfDay.hour - 1 > 12)
                    Text(
                      ((alarm.timeOfDay.hour - 13).toString() +
                          ':' +
                          alarm.timeOfDay.minute.toString() +
                          ' ~ ' +
                          alarm.timeOfDay.format(context)),
                      style: TextStyle(
                          color: Colors.white
                              .withOpacity(alarm.enabled ? 1.0 : 0.4),
                          fontSize: 15),
                    )
                  else
                    Text(
                      ((alarm.timeOfDay.hour - 1).toString() + ':' +
                          alarm.timeOfDay.minute.toString() + ' ~ ' +
                          alarm.timeOfDay.format(context)),
                      style: TextStyle(
                          color: Colors.white
                              .withOpacity(alarm.enabled ? 1.0 : 0.4),
                          fontSize: 15),
                    ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // IconButton를 누를 때 실행할 함수 또는 동작
                      onTapDelete(); // onTapDelete 함수 실행
                    },
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
