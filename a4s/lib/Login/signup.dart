import 'package:a4s/Login/signup_2.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/MainPage/main_page.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:get/get.dart';

/// 회원가입 화면
class SignUpPage extends ConsumerStatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextStyle style = TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  late TextEditingController _name;
  late TextEditingController _password;
  late TextEditingController _password2;
  late TextEditingController _email;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _password2 = TextEditingController(text: "");
    _email = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    return Scaffold(
      key: _key,
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('회원가입',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 50),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                child: TextFormField(
                  controller: _name,
                  validator: (value) => (value!.isEmpty) ? "이름을 입력해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "이름",
                    filled: true,
                    fillColor: Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                child: TextFormField(
                  controller: _email,
                  validator: (value) =>
                      (value!.isEmpty) ? "이메일을 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "이메일",
                    filled: true,
                    fillColor: Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                child: TextFormField(
                  obscureText: true,
                  controller: _password,
                  validator: (value) =>
                      (value!.isEmpty) ? "패스워드를 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "비밀번호",
                    filled: true,
                    fillColor: Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                child: TextFormField(
                  obscureText: true,
                  controller: _password2,
                  validator: (value) =>
                      (value != _password.text) ? "패스워드가 다릅니다" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "비밀번호 확인",
                    filled: true,
                    fillColor: Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                child: MaterialButton(
                  shape: CircleBorder(),
                  color: Color(0xff6694ff),
                  height: 80,
                  elevation: 10.0,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        Get.to(SignUpPage2(), arguments: {
                          'email': _email.value.text,
                          'password': _password.value.text,
                          'name': _name.value.text
                        });
                      } catch (e) {
                        print("$e 이메일 회원가입 실패");
                      }
                    }
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
      ),
    );
  }
}
