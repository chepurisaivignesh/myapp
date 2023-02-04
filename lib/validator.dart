class Validator {
  static String? validateField({required String value}) {
    if (value.isEmpty) {
      return "TextField cant be empty";
    }
    return null;
  }

  static String? validateUserId({required String uid}) {
    if (uid.isEmpty) {
      return "User Id cant be empty";
    } else if (uid.length <= 5) {
      return "User Id cant be 5 or less than 5 characters";
    }
    return null;
  }
}
