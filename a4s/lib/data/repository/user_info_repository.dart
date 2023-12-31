import 'package:firebase_auth/firebase_auth.dart';
import 'package:a4s/data/repository/auth_repository.dart';
import 'package:a4s/data/model/app_user.dart';
import 'package:a4s/data/datasource/remote_data_source.dart';

final userInfoRepositoryProvider = UserInfoRepository();

class UserInfoRepository {
  late final UserInfoDataSource _userInfoDataSource = UserInfoDataSource();

  Future<Map> getMyInfo({required String uid}) async {
    return await _userInfoDataSource.getMyInfo(uid: uid);
  }

  Future<bool> setMySleepInfo({
    required String uid,
    required String gender,
    required String height,
    required String weight,
    required String disease,
  }) async {
    return await _userInfoDataSource.setMySleepInfo(
        uid: uid,
        gender: gender,
        height: height,
        weight: weight,
        disease: disease);
  }

  Future<bool> updateMySleepInfo({
    required String uid,
    required String gender,
    required String height,
    required String weight,
    required String disease,
  }) async {
    return await _userInfoDataSource.updateMySleepInfo(
        uid: uid,
        gender: gender,
        height: height,
        weight: weight,
        disease: disease);
  }

  Future<bool> updateMyTimeInfo({
    required String uid,
    required String waketime
  }) async {
    return await _userInfoDataSource.updateMyTimeInfo(
        uid: uid,
        waketime: waketime);
  }
}
