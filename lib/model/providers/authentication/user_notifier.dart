import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AuthenticationNotifier extends Notifier<User?> {
//   AuthenticationNotifier() {
//     _getUserData();
//
//     Amplify.Hub.listen(HubChannel.Auth, (event) {
//       AuthUser? user = event.payload;
//
//       if (user == null) {
//         state = null;
//         return;
//       }
//
//       _getUserData();
//     });
//   }
//
//   @override
//   User? build() => null;
//
//   void _getUserData() async {
//     try {
//       List<AuthUserAttribute> attributes = await Amplify.Auth.fetchUserAttributes();
//
//       String email = attributes.firstWhere((attribute) => "email" == attribute.userAttributeKey.key).value;
//       String nickname = attributes.firstWhere((attribute) => "nickname" == attribute.userAttributeKey.key).value;
//
//       state = User(username: nickname, email: email);
//     } on AuthException catch (e) {
//       print(e.toString());
//     }
//   }
//
//   Future<String?> resetPassword(String email) async {
//     try {
//       await Amplify.Auth.resetPassword(username: email);
//     } on AuthException catch (e) {
//       return e.message;
//       //return "Error al restablecer la contraseña.";
//     }
//
//     return null;
//   }
//
//   Future<String?> confirmResetPassword(String email, String password, String code) async {
//     try {
//       Amplify.Auth.confirmResetPassword(username: email, newPassword: password, confirmationCode: code);
//     } on AuthException {
//       return "Error al restablecer la contraseña.";
//     }
//
//     return null;
//   }
//
//   Future<String?> verification(String email, String code) async {
//     Amplify.Auth.confirmSignUp(username: email, confirmationCode: code);
//
//     return "";
//   }
//
//   Future<String?> login(String email, String password) async {
//     try {
//       final result = await Amplify.Auth.signIn(
//         username: email,
//         password: password,
//       );
//
//       print(result.toJson());
//       return null;
//     } on NotAuthorizedServiceException {
//       return "Usuario o contraseña incorrectos.";
//     } on AuthException catch (e) {
//       print(e.message);
//       return "Error al iniciar sesión.";
//     }
//   }
//
//   Future<String?> logout() async {
//     SignOutResult result = await Amplify.Auth.signOut();
//     if (result is CognitoFailedSignOut) {
//       return 'Error signing user out: ${result.exception.message}';
//     }
//
//     return "";
//   }
//
//   Future<String?> updateData(AuthUserAttributeKey key, String value) async {
//     try {
//       UpdateUserAttributeResult result = await Amplify.Auth.updateUserAttribute(userAttributeKey: key, value: value);
//
//       if (result.isUpdated) return null;
//     } on AuthException {}
//
//     return "Error al actualizar.";
//   }
//
//   Future<String?> changePassword(String oldPassword, String password) async {
//     try {
//       UpdatePasswordResult result = await Amplify.Auth.updatePassword(oldPassword: oldPassword, newPassword: password);
//
//       return null;
//     } on AuthException {}
//
//     return "Error al actualizar contraseña.";
//   }
//
//   Future<String?> register(String username, String email, String password) async {
//     try {
//       final userAttributes = {
//         AuthUserAttributeKey.email: email,
//         AuthUserAttributeKey.nickname: username,
//       };
//
//       final result = await Amplify.Auth.signUp(
//         username: email,
//         password: password,
//         options: SignUpOptions(
//           userAttributes: userAttributes,
//         ),
//       );
//
//       print(result.toJson());
//       return null;
//     } on AuthException catch (e) {
//       print(e.message);
//
//       return e.message;
//     }
//   }
// }
//
// class User {
//   final String username, email;
//   final Uint8List? profileImage;
//
//   User({required this.username, required this.email, this.profileImage});
// }
