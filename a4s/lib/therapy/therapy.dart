import 'package:a4s/therapy/sleep_therapy.dart';
import 'package:a4s/therapy/white_sound.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TherapyPage extends StatefulWidget {
  const TherapyPage({super.key});

  @override
  _TherapyPage createState() => _TherapyPage();
}

class _TherapyPage extends State<TherapyPage> {
  int pageNum = 0;
  void getPageNum(int index) {
    setState(() {
      pageNum = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: ListView(
              children: [
                Text(
                  '좋은 수면을 위한 백색소음',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 60),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WhiteSound()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2016/09/08/21/09/piano-1655558_1280.jpg', // 이미지의 URL을 여기에 입력
                      ),
                    ),
                  ),
                ),
                Text('나를 위한 수면 정보',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TherapyInfo()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2016/12/30/17/27/cat-1941089_1280.jpg', // 이미지의 URL을 여기에 입력
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ));
  }
}
