import 'package:a4s/theme_data.dart';

import 'alarm_info.dart';

List<AlarmInfo> alarms = [
  AlarmInfo(DateTime.now().add(Duration(hours: 1)), description: 'Office',
      gradientColors: GradientColors.sky),
  AlarmInfo(DateTime.now().add(Duration(hours: 2)), description: 'Sport',
      gradientColors: GradientColors.sky2),
];