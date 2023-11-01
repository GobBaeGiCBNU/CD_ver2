import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TherapyInfo extends StatefulWidget {
  const TherapyInfo({super.key});

  @override
  _TherapyInfo createState() => _TherapyInfo();
}

class BlogModel {
  const BlogModel(this.linkUrl, this.imageUrl, this.title, this.desc);
  final String linkUrl;
  final String imageUrl;
  final String title;
  final String desc;
}

const blogList = [
  BlogModel(
      "https://mjh.or.kr/sleep/health/class/sleep-food.do",
      "https://cdn.pixabay.com/photo/2017/09/16/19/21/salad-2756467_1280.jpg",
      "수면에 좋은 음식",
      "명지병원"),
  BlogModel(
      "https://deogoonews.com/%EC%88%99%EB%A9%B4%EC%97%90%EC%A2%8B%EC%9D%80%ED%96%A5-%EC%88%98%EB%A9%B4%EC%97%90-%EB%8F%84%EC%9B%80%EC%9D%84-%EC%A3%BC%EB%8A%94-%EB%B0%A9%EB%B2%95/",
      "https://cdn.pixabay.com/photo/2017/07/16/22/22/bath-oil-2510783_1280.jpg",
      "수면에 좋은 향",
      "DEOGOONEWS"),
  BlogModel(
      "https://www.amc.seoul.kr/asan/healthstory/lifehealth/lifeHealthDetail.do?healthyLifeId=29289",
      "https://cdn.pixabay.com/photo/2017/08/02/20/24/woman-2573216_1280.jpg",
      "수면 밸런스 수칙",
      "서울아산병원"),
];

class _TherapyInfo extends State<TherapyInfo> {
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
                    child: Text('나를 위한 수면 정보',
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
                  itemCount: blogList.length,
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
                                launchUrlString(blogList[index].linkUrl);
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      blogList[index].imageUrl,
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
                                              blogList[index].title,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              blogList[index].desc,
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
