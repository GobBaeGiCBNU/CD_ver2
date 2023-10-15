import 'package:a4s/data/view/user_view_model.dart';
import 'package:a4s/myPage/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  _MyPage createState() => _MyPage();
}

class _MyPage extends ConsumerState<MyPage> {
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
              child: const Profile(),
            ),
            Container(
              child: const MyPageList(),
            )
          ],
        ));
  }
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    var size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02,
          size.width * 0.05, size.height * 0.02),
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Color(0xff6694ff)),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 100,
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.user!.name!,
                          style: TextStyle(
                              fontSize: const AdaptiveTextSize()
                                  .getadaptiveTextSize(context, 13),
                              color: const Color.fromRGBO(18, 32, 84, 1),
                              fontWeight: FontWeight.w700),
                        ),
                        Container(height: 10),
                        user.user!.email != null
                            ? Text(
                                user.user!.email!,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 12)),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )
                ]),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit,
                    size: 17.0,
                  ),
                  Container(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Edit()));
                      // 회원정보 수정 페이지로 이동
                    },
                    child: Text(
                      "내 정보 수정하기",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 10),
                          color: Colors.grey),
                    ),
                  )
                ],
              ),
            )
          ]),
    );
  }
}

class MyPageList extends StatelessWidget {
  const MyPageList({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var wSize = size.width * (2 / 6) + 20;
    return (Container(
      margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.02,
          size.width * 0.05, size.height * 0.02),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // padding: const EdgeInsets.all(8),
            width: wSize,
            height: size.height * 0.13,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color(0xff6694ff),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const MyTeam()),
                // );
                // 내 응원팀 경기일정 보기로 이동
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "내 수면 정보",
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 11),
                        fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.event_available,
                      color: Color.fromRGBO(18, 32, 84, 1))
                ],
              ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(8),
            width: wSize,
            height: size.height * 0.13,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color(0xff6694ff),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () {
                // 내 여행 일정 페이지로 이동
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const MyTravel()),
                // );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "수면 중 소음",
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 11),
                        fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.card_travel,
                      color: Color.fromRGBO(18, 32, 84, 1))
                ],
              ),
            ),
          )
        ],
      )),
    ));
  }
}
