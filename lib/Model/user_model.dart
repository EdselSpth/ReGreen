import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regreen/Model/area_status.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? photoUrl;
  final DateTime? createdAt;

  final AreaStatus areaStatus;
  final String? areaId;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.address,
    this.photoUrl,
    this.createdAt,
    this.areaStatus = AreaStatus.notRegistered,
    this.areaId,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      areaStatus: areaStatusFromString(map['areaStatus']),
      areaId: map['areaId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'areaStatus': areaStatusToString(areaStatus),
      'areaId': areaId,
    };
  }
}
