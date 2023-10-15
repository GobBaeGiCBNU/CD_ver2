import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  AppUser(
      {this.uid, this.name, this.email, this.gender, this.height, this.weight, this.disease});

  factory AppUser.fromJson(Map<String, String> json) {
    return AppUser(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        gender: json['gender'],
        height: json['height'],
        weight: json['weight'],
        disease: json['disease']);
  }

  factory AppUser.fromUser(User user) {
    return AppUser(uid: user.uid, name: user.displayName, email: user.email);
  }

  String? uid;
  String? name;
  String? email;
  String? gender;
  String? height;
  String? weight;
  String? disease;
}
