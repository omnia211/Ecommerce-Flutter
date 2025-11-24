class AppValidation{
  AppValidation._();

  static String? validateEmail(String? value){
    if(value == null || value.isEmpty){
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if(!emailRegex.hasMatch(value)){
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value){
    if(value == null || value.isEmpty){
      return 'Password is required';
    }
    if(value.length < 6){
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateUsername(String? value){
    if(value == null || value.isEmpty){
      return 'Username is required';
    }
    if(value.length < 3){
      return 'Username must be at least 3 characters';
    }
    return null;
  }


  static String? validatePhoneNumber(String? value){
    if(value == null || value.isEmpty){
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if(!phoneRegex.hasMatch(value)){
      return 'Enter a valid phone number';
    }
    return null;
  }


  static String? validateNotEmpty(String? value, String fieldName){
    if(value == null || value.isEmpty){
      return '$fieldName is required';
    }
    return null;
  }
}