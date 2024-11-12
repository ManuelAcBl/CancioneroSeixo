import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUserNotifier extends Notifier<User?> {
  @override
  User? build() {
    FirebaseAuth.instance.userChanges().listen((user) {
      print("[AUTH] User Changed!");
      state = user;
    });

    FirebaseAuth.instance.authStateChanges().listen((user) {
      print("[AUTH] Auth State Changed!");
    });

    return null;
  }

  Future<LoginError?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      return switch (exception.code) {
        "wrong-password" || "user-not-found" || "INVALID_LOGIN_CREDENTIALS" || "invalid-credential" => LoginError.credentials,
        "network-request-failed" => LoginError.network,
        _ => LoginError.error,
      };
    }

    return null;
  }

  Future<LoginError?> loginWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        ),
      );
    } on FirebaseAuthException catch (exception) {
      return switch (exception.code) {
        "wrong-password" || "user-not-found" || "INVALID_LOGIN_CREDENTIALS" || "invalid-credential" => LoginError.credentials,
        "network-request-failed" => LoginError.network,
        _ => LoginError.error,
      };
    }

    return null;
  }

  Future<RegisterError?> register(String username, String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(username);
    } on FirebaseAuthException catch (exception) {
      return switch (exception.code) {
        "network-request-failed" => RegisterError.network,
        _ => RegisterError.error,
      };
    }

    return null;
  }

  Future<void> logout() async => await FirebaseAuth.instance.signOut();

  Future<SendPasswordResetError?> sendResetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      return switch (exception.code) {
        "network-request-failed" => SendPasswordResetError.network,
        _ => SendPasswordResetError.error,
      };
    }

    return null;
  }

  Future<ConfirmPasswordResetError?> confirmResetPassword(String code, String password) async {
    try {
      await FirebaseAuth.instance.confirmPasswordReset(code: code, newPassword: password);
    } on FirebaseAuthException catch (exception) {
      return switch (exception.code) {
        "network-request-failed" => ConfirmPasswordResetError.network,
        _ => ConfirmPasswordResetError.error,
      };
    }

    return null;
  }
}

enum ConfirmPasswordResetError {
  network,
  error;
}

enum SendPasswordResetError {
  network,
  error;
}

enum RegisterError {
  network,
  error;
}

enum LoginError {
  error,
  credentials,
  network;
}
