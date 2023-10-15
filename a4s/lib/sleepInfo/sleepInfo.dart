import 'package:a4s/data/view/user_view_model.dart';
import 'package:a4s/myPage/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class SleepInfo extends ConsumerStatefulWidget {
  const SleepInfo({super.key});

  @override
  _SleepInfo createState() => _SleepInfo();
}

class _SleepInfo extends ConsumerState<SleepInfo> {
  int pageNum = 2;
  void getPageNum(int index) {
    setState(() {
      pageNum = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              // child: Calendar(),
            )
          ],
        ));
  }
}

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
