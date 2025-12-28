import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regreen/model/user_model.dart';
import 'package:regreen/model/auth_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await user.sendEmailVerification();

        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          username: username,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        await user.updateDisplayName(username);

        return newUser;
      }
      return null;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        if (!user.emailVerified) {
          await _auth.signOut();

          return AuthResult(
            errorCode: 'email-not-verified',
            errorMessage: 'Email belum diverifikasi. Cek inbox kamu!',
          );
        }
      }

      return AuthResult(user: user);
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'user-not-found') {
        message = 'Tidak ada pengguna yang terdaftar dengan email ini.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah.';
      } else if (e.code == 'invalid-credential') {
        message = 'Email atau password salah.';
      } else if (e.code == 'email-not-verified') {
        message = 'Email belum diverifikasi.';
      } else {
        message =
            e.message ?? 'Gagal login. Periksa koneksi atau kredensial Anda.';
      }

      return AuthResult(errorCode: e.code, errorMessage: message);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Email tidak terdaftar.');
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('Gagal mengirim email reset: $e');
    }
  }
}
