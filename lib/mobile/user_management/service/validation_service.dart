class ValidationService {
  static bool _validatePassword(String value) {
    const String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    return RegExp(pattern).hasMatch(value);
  }

  static bool _validateEmail(String email) {
    const String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    return RegExp(pattern).hasMatch(email);
  }

  static String? Function(String?)? none() => (value) {
        return null;
      };

  static String? Function(String?)? validateRegisterPassword(String? value) =>
      (value) {
        print('validating $value');
        if (value == null || value.isEmpty || !_validatePassword(value)) {
          return 'Password must be at least 8 characters long and have\n'
              '- Minimum 1 uppercase\n'
              '- Minimum 1 lowercase\n'
              '- Minimum 1 numeric number\n';
        }
        return null;
      };

  static String? Function(String?)? validateUsername(String? value) => (value) {
        if (value == null || value.isEmpty || value.length < 4) {
          return 'Username must be at least 4 characters long';
        }
        return null;
      };

  static String? Function(String?)? validateLoginPassword(String? value) =>
      (value) {
        if (value == null || value.isEmpty) {
          return 'Password field cannot be empty';
        }
        return null;
      };

  static String? Function(String?)? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) =>
      (value) {
        print(password);
        print(confirmPassword);
        if (value == null || value.isEmpty) {
          return 'Password field cannot be empty';
        }
        if (password != confirmPassword) {
          return 'Passwords do not match';
        }
        return null;
      };

  static String? Function(String?)? validateEmail(String? value) => (value) {
        if (value == null || value.isEmpty || !_validateEmail(value)) {
          return 'Enter a valid email';
        }
        return null;
      };

  static String? Function(String?)? validateOtp(String? value) => (value) {
        if (value == null || value.isEmpty || value.length != 6) {
          return 'The password must be 6 digits long';
        }
        return null;
      };

  static String? Function(String?)? validateGameId(String? value) => (value) {
        // TODO: check if gameIdController.text.trim() is a valid game ID
        if (value == null || value.isEmpty) {
          return 'Enter a game name';
        }
        return null;
      };
}
