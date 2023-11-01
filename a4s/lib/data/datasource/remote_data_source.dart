import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';

class remoteDataSource {
  ///네트워크 연결 확인
  Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

///인증에 관련된 외부데이터소스
class AuthDataSource extends remoteDataSource {
  ///카카오를 통한 간편로그인
  Future<User> GoogleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential awitAsult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = awitAsult.user;

    print("로그인 진입------------------------------");

    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);

    final User currentUser = await FirebaseAuth.instance.currentUser!;
    assert(user!.uid == currentUser.uid);

    if (user?.displayName == null) {
      await user?.updateDisplayName(googleUser.displayName);
    }
    print("로그인 성공 ${user!.displayName}");
    return user;
  }

  ///로그아웃
  ///로컬에 저장된 카카오 로그인 정보와 파이버베이스 로그인 정보 삭제
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  ///이메일 회원가입
  Future<User> emailSignUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    throw Exception("이메일 회원가입 실패");
  }

  ///이메일 로그인
  Future<User> emailSignIn(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    throw Exception("이메일 로그인 실패");
  }

  ///비밀번호 재설정 이메일 보내기
  Future<void> sendPasswordResetEmail({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  ///유저비밀번호 업데이트
  Future<void> updatePassword({required String newPassword}) async {
    await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
  }

  ///유저 정보 업데이트
  Future<void> updateUserInfo(
      {required String email, required String name}) async {
    await FirebaseAuth.instance.currentUser?.updateEmail(email);
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
  }
}

///인증정보를 제외한 유저 정보에 관련된 외부데이터소스
class UserInfoDataSource {
  Future<bool> setMySleepInfo({
    required String uid,
    required String gender,
    required String height,
    required String weight,
    required String disease,
  }) async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("users").doc(uid).set({
        "id": uid,
        "gender": gender,
        "height": height,
        "weight": weight,
        "disease": disease
      });
    } catch (e) {
      print("회원 수면 정보 업데이트 오류 (remote_data_source)");
      return false;
    }
    return true;
  }

  ///응원팀 생성 및 업데이트
  Future<bool> updateMySleepInfo({
    required String uid,
    required String gender,
    required String height,
    required String weight,
    required String disease,
  }) async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("users").doc(uid).update({
        "id": uid,
        "gender": gender,
        "height": height,
        "weight": weight,
        "disease": disease
      });
    } catch (e) {
      print("회원 수면 정보 업데이트 오류 (remote_data_source)");
      return false;
    }
    return true;
  }

  // 알람 울리는 시간 정보 설정
  Future<bool> updateMyTimeInfo(
      {required String uid, required String waketime}) async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("users").doc(uid).update({"waketime": waketime});
    } catch (e) {
      print("회원 기상 정보 업데이트 오류 (remote_data_source)");
      return false;
    }
    return true;
  }

  ///유저 정보 조회
  Future<Map> getMyInfo({required String uid}) async {
    final db = FirebaseFirestore.instance;
    DocumentSnapshot teamDoc = await db.collection("users").doc(uid).get();
    Map data = teamDoc.data() as Map<String, dynamic>;

    return data;
  }
}

class ChatDataSource {
  ///채팅 데이터 저장
  Future<void> addChat(
      {required String team,
      required String text,
      required String uid,
      required String writer}) async {
    FirebaseFirestore.instance
        .collection('teams')
        .doc(team)
        .collection("chat")
        .add({
      "text": text,
      "time": DateTime.now(),
      "uid": uid,
      "writer": writer
    });
  }

  Stream<QuerySnapshot<Object?>>? getChatStream({required String team}) {
    return FirebaseFirestore.instance
        .collection('teams')
        .doc(team)
        .collection("chat")
        .orderBy("time")
        .limit(1000)
        .snapshots();
  }
}
