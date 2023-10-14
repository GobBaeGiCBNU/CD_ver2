import 'package:a4s/alarm/data.dart';
import 'package:a4s/notification.dart';
import 'package:a4s/theme_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:a4s/model/alarm.dart';
import 'package:a4s/provider/alarm_list_provider.dart';
import 'package:a4s/service/alarm_scheduler.dart';
import 'package:provider/provider.dart' as provider;


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
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            _createAlarm(context, context.read<AlarmListProvider>());
          },
          child: const Icon(Icons.add, color: Colors.white,),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: provider.Consumer<AlarmListProvider>(
                  builder: (context, alarmList, child) =>
                      ListView.builder(
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
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

void _createAlarm(BuildContext context,
    AlarmListProvider alarmListProvider,) async {
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

void _switchAlarm(AlarmListProvider alarmListProvider,
    Alarm alarm,
    bool enabled,) async {
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

void _handleCardTap(AlarmListProvider alarmList,
    Alarm alarm,
    BuildContext context,) async {
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

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    Key? key,
    required this.alarm,
    required this.onTapSwitch,
    required this.onTapCard,
  }) : super(key: key);

  final Alarm alarm;
  final void Function(bool enabled) onTapSwitch;
  final VoidCallback onTapCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onTapCard,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  alarm.timeOfDay.format(context),
                  style: theme.textTheme.headline6!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(
                      alarm.enabled ? 1.0 : 0.4,
                    ),
                  ),
                ),
              ),
              Switch(
                value: alarm.enabled,
                onChanged: onTapSwitch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}