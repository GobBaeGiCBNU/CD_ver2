import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/data/model/app_user.dart';
import 'package:a4s/data/repository/auth_repository.dart';
import 'package:a4s/data/repository/user_info_repository.dart';
import 'package:flutter/foundation.dart';

final userViewModelProvider =
    ChangeNotifierProvider<UserViewModel>((ref) => UserViewModel());

class UserViewModel extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  bool get isAuthenticated => _user != null;

  // Future<void> kakaoSignIn() {
  //   return authRepositoryProvider.kakaoSignIn().then((result) async {
  //     _user = result;
  //     try {
  //       _user!.team =
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
  }) {
    return authRepositoryProvider
        .emailSignUp(
            email: email,
            password: password,
            name: name,
            gender: gender,
            height: height,
            weight: weight)
        .then((result) {
      _user = result;
      _user!.name = name;
      userInfoRepositoryProvider.updateMyTeam(uid: _user!.uid!);
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

  Future<void> updateTeam({required String team}) async {
    return await userInfoRepositoryProvider
        .updateMyTeam(uid: _user!.uid!)
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
  Future<void> updateUserInfo(
      {required String uid,
      required String email,
      required String name}) async {
    await authRepositoryProvider.updateUserInfo(email: email, name: name);
    _user!.email = email;
    _user!.name = name;
    await userInfoRepositoryProvider.updateMyTeam(uid: uid);
    notifyListeners();
  }
}
