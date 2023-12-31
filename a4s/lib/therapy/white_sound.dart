import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WhiteSound extends StatefulWidget {
  const WhiteSound({super.key});

  @override
  _WhiteSound createState() => _WhiteSound();
}

class SoundModel {
  const SoundModel(this.linkUrl, this.imageUrl, this.title, this.desc);
  final String linkUrl;
  final String imageUrl;
  final String title;
  final String desc;
}

const soundList = [
  SoundModel(
      "https://www.youtube.com/watch?v=EBSegrHpreY",
      "https://cdn.pixabay.com/photo/2019/08/19/07/45/corgi-4415649_1280.jpg",
      "자연/피아노 - 비",
      "Youtube"),
  SoundModel(
      "https://www.youtube.com/watch?v=PiGt5HTSRec",
      "https://cdn.pixabay.com/photo/2018/03/03/21/14/piano-3196616_1280.jpg",
      "피아노",
      "Youtube"),
  SoundModel(
      "https://www.youtube.com/watch?v=4zqKJBxRyuo",
      "https://cdn.pixabay.com/photo/2014/02/01/19/45/water-256346_1280.jpg",
      "자연 - 바다",
      "Youtube"),
];

class _WhiteSound extends State<WhiteSound> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      margin: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 60,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 15,
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, left: 10),
                    child: Text('좋은 수면을 위한 백색소음',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: soundList.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                            // color: Colors.yellow,
                            width: 400,
                            height: 150,
                            padding: EdgeInsets.all(20),
                            child: GestureDetector(
                              onTap: () {
                                launchUrlString(soundList[index].linkUrl);
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      soundList[index].imageUrl,
                                      width: 150,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      // color: Colors.green,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 12),
                                            child: Text(
                                              soundList[index].title,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              soundList[index].desc,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Divider(),
                      ],
                    );
                  })),
        ],
      ),
    );
  }
}
