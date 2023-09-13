import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return SingleChildScrollView(
        child: Column(
      children: [Text("1"), Text("1")],
    ));
  }
}
