import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/myPage/reset_password.dart';

class Edit extends ConsumerStatefulWidget {
  const Edit({super.key});

  @override
  _EditState createState() => _EditState();
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

class _EditState extends ConsumerState<Edit> {
  TextStyle style = TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  late TextEditingController _email;
  late TextEditingController _name;
  late TextEditingController _weight;
  late TextEditingController _height;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late SingleValueDropDownController _disease;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  List<DropDownValueModel> dropDownListGender = [
    DropDownValueModel(name: "여자", value: "여자"),
    DropDownValueModel(name: "남자", value: "남자")
  ];

  List<DropDownValueModel> dropDownListDisease = [
    DropDownValueModel(name: "해당 없음", value: "해당 없음"),
    DropDownValueModel(name: "불면증", value: "불면증")
  ];

  @override
  void initState() {
    super.initState();
    final readUser = ref.read(userViewModelProvider);
    print(readUser.user!.height);
    _email = TextEditingController(text: readUser.user!.email);
    _name = TextEditingController(text: readUser.user!.name);
    _weight = TextEditingController(text: readUser.user!.weight);
    _height = TextEditingController(text: readUser.user!.height);
    _cnt = SingleValueDropDownController(
      data: DropDownValueModel(name: readUser.user!.gender!, value: readUser.user!.gender!)
    );
    _disease = SingleValueDropDownController(
      data: DropDownValueModel(name: readUser.user!.disease!, value: readUser.user!.disease!)
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _weight.dispose();
    _height.dispose();
    _cnt.dispose();
    _disease.dispose();
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
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('회원정보 수정',
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 18),
                        fontWeight: FontWeight.w600,)),
              ),
              const SizedBox(height: 30),
              user.user!.email == null || user.user?.email == ""
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30),
                      child: TextFormField(
                        controller: _email,
                        validator: (value) =>
                            (value!.isEmpty) ? "이메일을 입력 해 주세요" : null,
                        style: style,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          labelText: "이메일 변경",
                          labelStyle: TextStyle(color: Color(0xff6499ff)),
                          filled: true,
                          fillColor: const Color(0xffF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: _name,
                  validator: (value) =>
                      (value!.isEmpty) ? "이름을 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: "이름 변경",
                    labelStyle: TextStyle(color: Color(0xff6499ff)),
                    filled: true,
                    fillColor: const Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
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
                        labelStyle: TextStyle(color: Color(0xff6499ff)),
                        filled: true,
                        fillColor: const Color(0xffF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        )),
                    dropDownList: dropDownListGender,
                    controller: _cnt),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: _height,
                  validator: (value) => (value!.isEmpty) ? "키를 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.height),
                    labelText: "키 변경",
                    labelStyle: TextStyle(color: Color(0xff6499ff)),
                    filled: true,
                    fillColor: const Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: _weight,
                  validator: (value) =>
                      (value!.isEmpty) ? "몸무게를 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.line_weight),
                    labelText: "몸무게 변경",
                    labelStyle: TextStyle(color: Color(0xff6499ff)),
                    filled: true,
                    fillColor: const Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: DropDownTextField(
                    validator: (value) => (_disease.dropDownValue == null)
                        ? "기저질환을 선택해 주세요"
                        : null,
                    clearOption: false,
                    textFieldFocusNode: textFieldFocusNode,
                    searchFocusNode: searchFocusNode,
                    dropDownItemCount: 2,
                    searchShowCursor: false,
                    searchKeyboardType: TextInputType.number,
                    textFieldDecoration: InputDecoration(
                        prefixIcon: const Icon(Icons.sick),
                        labelText: "기저질환",
                        labelStyle: TextStyle(color: Color(0xff6499ff)),
                        filled: true,
                        fillColor: const Color(0xffF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        )),
                    dropDownList: dropDownListDisease,
                    controller: _disease),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                child: MaterialButton(
                    shape: CircleBorder(),
                    color: Color(0xff6694ff),
                    height: 80,
                    elevation: 10.0,
                    onPressed: () {
                      user.updateUserInfo(
                          uid: user.user!.uid!,
                          email: _email.value.text,
                          name: _name.value.text,
                          weight: _weight.value.text,
                          height: _height.value.text,
                          gender: _cnt.dropDownValue!.value,
                          disease: _disease.dropDownValue!.value
                          );
                      showDialog(
                        context: context,
                        barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
                        builder: ((context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            title: const Text("회원정보 수정"),
                            content: const Text("회원 정보가 수정되었습니다."),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); //창 닫기
                                },
                                child: const Text("X"),
                              )
                            ],
                          );
                        }),
                      );
                    },
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    )),
              ),
            ],
          ),
        ));
  }
}
