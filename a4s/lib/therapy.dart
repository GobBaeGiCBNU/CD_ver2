import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TherapyPage extends StatefulWidget {
  const TherapyPage({super.key});

  @override
  _TherapyPage createState() => _TherapyPage();
}

class _TherapyPage extends State<TherapyPage>{
  int pageNum = 0;
  void getPageNum(int index) {
    setState(() {
      pageNum = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text( '좋은 수면을 위한 백색소음',
                    style: TextStyle(fontSize: 20),),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 40),
                    child: GestureDetector(
                      onTap: () {
                        launchUrlString('https://www.youtube.com/watch?v=xmUoDYwbi2c'); // 클릭하면 열고자 하는 URL을 여기에 입력
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                            'https://cdn.pixabay.com/photo/2014/01/23/21/33/blue-250770_1280.jpg', // 이미지의 URL을 여기에 입력
                            width: 400,
                            height: 200,
                          ),
                      ),
                    ),
                  ),

                  Text( '좋은 수면을 위한 백색소음',
                    style: TextStyle(fontSize: 20),),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 40),
                    child: GestureDetector(
                      onTap: () {
                        launchUrlString('https://www.youtube.com/watch?v=xmUoDYwbi2c'); // 클릭하면 열고자 하는 URL을 여기에 입력
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          'https://cdn.pixabay.com/photo/2014/01/23/21/33/blue-250770_1280.jpg', // 이미지의 URL을 여기에 입력
                          width: 400,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            )
          ],
        )
    );
  }
}

