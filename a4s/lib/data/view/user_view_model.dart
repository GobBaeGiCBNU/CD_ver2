import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/data/model/app_user.dart';
import 'package:a4s/data/repository/auth_repository.dart';
import 'package:a4s/data/repository/user_info_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userViewModelProvider =
    ChangeNotifierProvider<UserViewModel>((ref) => UserViewModel());

class UserViewModel extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  bool get isAuthenticated => _user != null;

  // Future<void> GoogleSignIn() {
  //   return authRepositoryProvider.GoogleSignIn().then((result) async {
  //     _user = result;
  //     try {
  //       _user!.gender =
  //           await userInfoRepositoryProvider.getMyTeam(uid: _user!.uid!);
  //     } catch (e) {
  //       //처음 카카오 로그인
  //     }
  //     notifyListeners();
  //   });
  // }

  Future<void> emailSignUp({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String height,
    required String weight,
    required String disease,
  }) {
    return authRepositoryProvider
        .emailSignUp(email: email, password: password, name: name)
        .then((result) {
      _user = result;
      _user!.name = name;
      userInfoRepositoryProvider.updateMySleepInfo(
          uid: _user!.uid!,
          gender: gender,
          height: height,
          weight: weight,
          disease: disease);
      _user!.weight = weight;
      _user!.height = height;
      _user!.gender = gender;
      _user!.disease = disease;
      notifyListeners();
    });
  }

  Future<void> emailSignIn({required String email, required String password}) {
    return authRepositoryProvider
        .emailSignIn(
      email: email,
      password: password,
    )
        .then((result) async {
      _user = result;
      notifyListeners();
    });
  }

  Future<void> updateSleepInfo({
    required String uid,
    required String gender,
    required String height,
    required String weight,
    required String disease,
  }) async {
    return await userInfoRepositoryProvider
        .updateMySleepInfo(
            uid: _user!.uid!,
            gender: gender,
            height: height,
            weight: weight,
            disease: disease)
        .then((result) {
      notifyListeners();
    });
  }

  bool autoSignIn() {
    final tempUser = authRepositoryProvider.autoSignIn();
    if (tempUser != null) {
      _user = tempUser;
      userInfoRepositoryProvider.getMyTeam(uid: _user!.uid!).then((value) {
        notifyListeners();
      });
      return true;
    } else {
      return false;
    }
  }

  Future signOut() {
    return authRepositoryProvider.signOut().then((result) {
      _user = null;
      notifyListeners();
    });
  }

  ///비밀번호 재설정 이메일 보내기
  Future<void> sendPasswordResetEmail({required String email}) async {
    await authRepositoryProvider.sendPasswordResetEmail(email: email);
  }

  ///비밀번호 재설정
  Future<void> updatePassword({required String newPassword}) async {
    await authRepositoryProvider.updatePassword(newPassword: newPassword);
  }

  ///유저 정보 업데이트
  Future<void> updateUserInfo({
    required String uid,
    required String email,
    required String name,
    required String gender,
    required String height,
    required String weight,
    required String disease,
  }) async {
    await authRepositoryProvider.updateUserInfo(email: email, name: name);
    _user!.email = email;
    _user!.name = name;
    await userInfoRepositoryProvider.updateMySleepInfo(
        uid: uid,
        gender: gender,
        height: height,
        weight: weight,
        disease: disease);
    _user!.weight = weight;
    _user!.height = height;
    _user!.gender = gender;
    _user!.disease = disease;
    notifyListeners();
  }
}
