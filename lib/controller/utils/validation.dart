abstract class Validation {
  static String? emailValidation(String text) {
    if (text.isEmpty) return 'Este campo no puede estar vacío.';

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text)) return 'El correo no tiene un formato válido (ejemplo@correo.com)';

    return null;
  }

  static String? passwordValidation(String text) {
    if (text.isEmpty) return 'Este campo no puede estar vacío.';

    if (text.length < 8) return 'La contraseña debe contener al menos 8 carácteres.';

    return null;
  }

  static String? usernameValidation(String text) {
    if (text.isEmpty) return 'Este campo no puede estar vacío.';

    if (text.length <= 3) return 'El nombre de usuario debe tener al menos 3 caracteres';

    return null;
  }

  static String? textValidation(String text) {
    if (text.isEmpty) return 'Este campo no puede estar vacío.';

    return null;
  }

  static String? resetCodeValidation(String text) {
    if (text.isEmpty) return 'Este campo no puede estar vacío.';

    if (text.length != 6) return 'El código debe contener 6 carácteres.';

    return null;
  }
}
