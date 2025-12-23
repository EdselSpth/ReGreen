import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;
  final String? errorMessage;
  final String? errorCode;

  AuthResult({this.user, this.errorMessage, this.errorCode});

  bool get isSuccess => user != null;
}
