import 'package:a4s/notification.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/data/view/user_view_model.dart';
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
    initialTime: TimeOfDay.now(),
  );
  print(time);
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
    final user = ref.watch(userViewModelProvider);

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
                        waketime: user.user!.waketime!,
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
    required this.waketime,
    required this.alarm,
    required this.onTapSwitch,
    required this.onTapCard,
    required this.onTapDelete,
  }) : super(key: key);

  final Alarm alarm;
  final String waketime;
  final void Function(bool enabled) onTapSwitch;
  final VoidCallback onTapCard;
  final VoidCallback onTapDelete;

  TimeOfDay userWakeTime(String waketime, TimeOfDay userTime) {
    TimeOfDay wakeTime = TimeOfDay(
      hour: userTime.hour,
      minute: userTime.minute,
    );

    switch (waketime) {
      case "30분":
      wakeTime = TimeOfDay(
        hour: wakeTime.hour,
        minute: wakeTime.minute - 30,
      );
      if (wakeTime.minute < 0) {
        wakeTime = TimeOfDay(
          hour: wakeTime.hour - 1,
          minute: 60 + wakeTime.minute,
        );
        if (wakeTime.hour < 0) {
          wakeTime = TimeOfDay(
            hour: wakeTime.hour + 24,
            minute: 60 + wakeTime.minute,
          );
        }
      }
      break;
    case "1시간":
      wakeTime = TimeOfDay(
        hour: wakeTime.hour - 1,
        minute: wakeTime.minute,
      );
      if (wakeTime.hour < 0) {
        wakeTime = TimeOfDay(
          hour: wakeTime.hour + 24,
          minute: wakeTime.minute,
        );
      }
      else if (wakeTime.hour > 12) {
        wakeTime = TimeOfDay(
          hour: wakeTime.hour - 12,
          minute: wakeTime.minute,
        );
      }
      break;
    case "1시간 30분":
      wakeTime = TimeOfDay(
        hour: wakeTime.hour - 1,
        minute: wakeTime.minute - 30,
      );
      if (wakeTime.minute < 0) {
        wakeTime = TimeOfDay(
          hour: wakeTime.hour - 1,
          minute: 60 + wakeTime.minute,
        );
        if (wakeTime.hour < 0) {
          wakeTime = TimeOfDay(
            hour: wakeTime.hour + 24,
            minute: wakeTime.minute,
          );
        }
      }
      break;
    case "2시간":
      wakeTime = TimeOfDay(
        hour: wakeTime.hour - 2,
        minute: wakeTime.minute,
      );
      if (wakeTime.hour < 0) {
        wakeTime = TimeOfDay(
          hour: wakeTime.hour + 24,
          minute: wakeTime.minute,
        );
      }
      break;
      default:
        wakeTime = wakeTime;
        break;
    }

    return wakeTime;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TimeOfDay time = userWakeTime(waketime, alarm.timeOfDay);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {
        print('Dismissed with direction $direction');
        // Your deletion logic goes here.
      },
      confirmDismiss: (DismissDirection direction) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('알림을 삭제하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    onTapDelete();
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                )
              ],
            );
          },
        );
        print('Deletion confirmed: $confirmed');
        return confirmed;
      },
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: onTapCard,
          child: Container(
            // 알람끼리 간격
            // margin: const EdgeInsets.only(bottom: 20),
            // box 내부 글씨 padding
            // padding: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text(
                            alarm.timeOfDay.format(context),
                            style: theme.textTheme.headline6!.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(
                                alarm.enabled ? 1.0 : 0.4,
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Text(
                          (time.hour.toString() +
                              ':' +
                              time.minute.toString() +
                              ' ~ ' +
                              alarm.timeOfDay.format(context) +
                              ' 사이에 알람이 울려요'),
                          style: TextStyle(
                              color: Colors.white
                                  .withOpacity(alarm.enabled ? 1.0 : 0.4),
                              fontSize: 13),
                        )
                      ],
                    ),
                    Switch(
                        value: alarm.enabled,
                        onChanged: onTapSwitch,
                        activeColor: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
