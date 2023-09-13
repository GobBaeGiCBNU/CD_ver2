import 'package:firebase_auth/firebase_auth.dart';
import 'package:a4s/data/repository/auth_repository.dart';
import 'package:a4s/data/model/app_user.dart';
import 'package:a4s/data/datasource/remote_data_source.dart';

final userInfoRepositoryProvider = UserInfoRepository();

class UserInfoRepository {
  late final UserInfoDataSource _userInfoDataSource = UserInfoDataSource();

  Future<String> getMyTeam({required String uid}) async {
    return await _userInfoDataSource.getMyTeam(uid: uid);
  }

  Future<bool> updateMyTeam({required String uid}) async {
    return await _userInfoDataSource.updateMyTeam(uid: uid);
  }
}
