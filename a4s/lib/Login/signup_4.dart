import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/MainPage/main_page.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

/// 회원가입 화면
class SignUpPage4 extends ConsumerStatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage4> {
  TextStyle style = TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  final _key = GlobalKey<ScaffoldState>();
  List wakeTime = ['30분', '1시간', '1시간 30분', '2시간'];
  int i = 1;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    return Scaffold(
      key: _key,
      appBar: AppBar(),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text('알람 시간 범위 설정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: '마지막 단계에요!',
                      style: TextStyle(fontSize: 15, color: Color(0xff616161)))
                ]))),
            SizedBox(height: 40),
            Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'A4S',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff6694ff))),
                    TextSpan(
                        text:
                            '는 사용자의 수면 단계를 분석하여\n사용자가 가장 개운하게 일어날 수 있는 시간에\n알람을 울려주는 서비스입니다.\n\n사용자가 알람 시간을 설정하게 되면,\n설정된 시간 ',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff616161))),
                    TextSpan(
                        text: '전 1시간 ~ 설정한 시간 내',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff6694ff),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            '에서\n가장 적절한 시간에 알람이 울리게 됩니다.\n\n알람 시간 범위는 설정에서 수정 가능하며,\n기상 후 설문 조사를 통해서도 변경 가능합니다.',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff616161))),
                  ]))),
            ),
            SizedBox(height: 30),
            Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '1시간을 가장 권장드려요!',
                    style: TextStyle(color: Color(0xff616161), fontSize: 11),
                  )),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        side: BorderSide(width: 1, color: Color(0xff6694ff))),
                    onPressed: () {
                      setState(() {
                        if (i > 0) {
                          i--;
                        } else
                          i;
                      });
                    },
                    child: Icon(
                      Icons.remove,
                      color: Color(0xff6694ff),
                      size: 20,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      wakeTime[i],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        side: BorderSide(width: 1, color: Color(0xff6694ff))),
                    onPressed: () {
                      setState(() {
                        if (i < wakeTime.length - 1) {
                          i++;
                        } else
                          i;
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: Color(0xff6694ff),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: Size(100, 50),
                      backgroundColor: Color(0xff6694ff),
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                        (route) => false);
                  },
                  child: Text(
                    '시작하기',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
