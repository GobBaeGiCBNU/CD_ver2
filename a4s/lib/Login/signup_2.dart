import 'package:a4s/Login/signup_3.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/MainPage/main_page.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:get/get.dart';

/// 회원가입 화면
class SignUpPage2 extends ConsumerStatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage2> {
  TextStyle style = TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  late TextEditingController _name;
  late TextEditingController _gender;
  late TextEditingController _weight;
  late TextEditingController _height;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  List<DropDownValueModel> dropDownValueList = [
    DropDownValueModel(name: "여자", value: "여자"),
    DropDownValueModel(name: "남자", value: "남자")
  ];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: '${Get.arguments['name']}');
    _gender = TextEditingController(text: "");
    _weight = TextEditingController(text: "");
    _height = TextEditingController(text: "");
    _cnt = SingleValueDropDownController();
  }

  @override
  void dispose() {
    _name.dispose();
    _gender.dispose();
    _weight.dispose();
    _height.dispose();
    _cnt.dispose();
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
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: '정확한 ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff6694ff),
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '수면 분석',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff6694ff),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '을 위해 필요한 자료들이에요.',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff616161)))
                  ]))),
              SizedBox(height: 30),
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
                child: DropDownTextField(
                    validator: (value) =>
                        (_cnt.dropDownValue == null) ? "성별을 선택해 주세요" : null,
                    clearOption: false,
                    textFieldFocusNode: textFieldFocusNode,
                    searchFocusNode: searchFocusNode,
                    dropDownItemCount: 2,
                    searchShowCursor: false,
                    searchKeyboardType: TextInputType.number,
                    textFieldDecoration: InputDecoration(
                        prefixIcon: const Icon(Icons.favorite),
                        labelText: "성별",
                        filled: true,
                        fillColor: const Color(0xffF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        )),
                    dropDownList: dropDownValueList,
                    controller: _cnt),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                child: TextFormField(
                  controller: _height,
                  validator: (value) => (value!.isEmpty) ? "키를 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.height),
                    labelText: "키",
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
                  controller: _weight,
                  validator: (value) =>
                      (value!.isEmpty) ? "몸무게를 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.line_weight),
                    labelText: "몸무게",
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
                        await user.emailSignUp(
                          email: "${Get.arguments['email']}",
                          password: "${Get.arguments['password']}",
                          name: "${Get.arguments['name']}",
                          gender: _cnt.dropDownValue!.value,
                          height: _height.value.text,
                          weight: _weight.value.text,
                          //disease: _disease.dropdownvalue.value
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage3()));
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
