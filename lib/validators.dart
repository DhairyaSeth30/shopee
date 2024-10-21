class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );
  // Regular expression pattern for GST number validation
  static final RegExp gstRegex = RegExp(
    r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[0-9A-Z]{2}$",
  );

  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z0-9_.+-]+$',
  );

  static String? isValidEmail(String? value) {
    final email = value?.toLowerCase().trimRight();
    if (email == null || email.isEmpty) {
      return 'Please enter email';
    } else {
      if (!_emailRegExp.hasMatch(email)) {
        return 'Please enter valid email';
      } else {
        return null;
      }
    }
  }

  static String? isValidPassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter password';
    } else {
      if (!_passwordRegExp.hasMatch(password)) {
        return 'Password must be of length 8 or more including special character, upper case and lowercase';
      } else {
        return null;
      }
    }
  }

  static String? isValidName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter name';
    } else {
      return null;
    }
  }
  static String? isValidGSTNumber(String? gstNumber) {
    if (gstNumber == null || gstNumber.isEmpty) {
      return 'Please enter GST number';
    } else {
      // GST number should be exactly 15 characters long
      if (gstNumber.length != 15) {
        return 'GST number should be 15 characters long';
      }

      //
      // // Check if the GST number matches the regular expression pattern
      // if (!gstRegex.hasMatch(gstNumber)) {
      //   return 'Invalid GST number format';
      // }

      // If all conditions pass, return null to indicate a valid GST number
      return null;
    }
  }

  static String? inValidOTP(String? otp) {
    if (otp == null || otp.isEmpty) {
      return 'This field is required';
    } else if (otp.length < 6) {
      return 'All fields must be completed';
    }
    return null;
  }

}
