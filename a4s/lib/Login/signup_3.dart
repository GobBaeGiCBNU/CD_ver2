import 'package:a4s/Login/signup_4.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

/// 회원가입 화면
class SignUpPage3 extends ConsumerStatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage3> {
  TextStyle style = TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  final _key = GlobalKey<ScaffoldState>();

  Future<bool> requestPermission() async {
    // 권한 요청
    Map<Permission, PermissionStatus> statues =
        await [Permission.microphone, Permission.sensors].request();
    print('per1 : $statues');
    // 결과 확인
    if (!statues.values.every((element) => element.isGranted)) {
      // 허용이 안된 경우
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // 권한없음을 다이얼로그로 알림
            return AlertDialog(
              content: const Text("권한 설정을 확인해주세요."),
              actions: [
                TextButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: const Text('설정하기')),
              ],
            );
          });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUpPage4()));
    }
    return true;
  }

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
              child: Text('권한 허용',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: '원활한 앱 사용을 위해 필요한 권한들이에요.',
                      style: TextStyle(fontSize: 15, color: Color(0xff616161)))
                ]))),
            SizedBox(height: 40),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff6694ff), width: 1.2),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Icon(
                          Icons.directions_run,
                          color: Color(0xff6694ff),
                          size: 40,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "피트니스 열람",
                                  style: TextStyle(
                                      color: Color(0xff6694ff),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                              child: Text(
                                "심박수 등 수면 데이터 수집에 필요한 권한이에요",
                                style: TextStyle(
                                    color: Color(0xff616161), fontSize: 14),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff6694ff), width: 1.2),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Icon(
                          Icons.mic,
                          color: Color(0xff6694ff),
                          size: 40,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "피트니스 열람",
                                  style: TextStyle(
                                      color: Color(0xff6694ff),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                              child: Text(
                                "심박수 등 수면 데이터 수집에 필요한 권한이에요",
                                style: TextStyle(
                                    color: Color(0xff616161), fontSize: 14),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            SizedBox(height: 40),
            SizedBox(
              child: MaterialButton(
                shape: CircleBorder(),
                color: Color(0xff6694ff),
                height: 80,
                elevation: 10.0,
                onPressed: () async {
                  requestPermission();
                },
                child: Icon(
                  Icons.arrow_right_alt,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class PermissionManage{
//   /// 센서, 녹음 권한 요청
//   Future<bool> requestPermission(BuildContext context) async {
//     // 권한 요청
//     Map<Permission, PermissionStatus> permissions = await [Permission.microphone, Permission.sensors].request();
//     print('per1 : $permissions');
//     // 결과 확인
//     if(!permissions.values.every((element) => element.isGranted)) { // 허용이 안된 경우
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             // 권한없음을 다이얼로그로 알림
//             return AlertDialog(
//               content: const Text("권한 설정을 확인해주세요."),
//               actions: [
//                 TextButton(
//                     onPressed: () {
//                       openAppSettings(); // 앱 설정으로 이동
//                     },
//                     child: const Text('설정하기')),
//               ],
//             );
//           });
//       return false;
//     }
//     return true;
//   }
// }