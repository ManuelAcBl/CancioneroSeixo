import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/authentication/app_user_notifier.dart';
import 'package:cancionero_seixo/model/providers/authentication/firebase_authentication_notifier.dart';

abstract class AuthProviders {
  //static final user = NotifierProvider<AuthenticationNotifier, User?>(AuthenticationNotifier.new);
  static final firebase = NotifierProvider<FirebaseUserNotifier, User?>(FirebaseUserNotifier.new);
  static final user = NotifierProvider<AppUserNotifier, AppUser>(AppUserNotifier.new);
}
