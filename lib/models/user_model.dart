import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id, uid, name, email, phone,avatar;
  final bool gender;

  UserModel(
      {required this.id,
      required this.uid,
      required this.name,
      required this.email,
      required this.avatar,
      required this.gender,
      required this.phone,
      });

  factory UserModel.fromfirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      uid: data['uid'],
      name: data['username'],
      email: data['email'],
      avatar: data['avatar'],
      gender: data['gender'],
      phone: data['phone']
    );
  }
}