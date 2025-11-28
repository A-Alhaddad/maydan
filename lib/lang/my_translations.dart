import 'package:maydan/widgets/my_library.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "ar": {
      "signInTitle": "تسجيل الدخول",
      "phoneNumber": "رقم الهاتف",
      "enterPhone": "ادخل رقم الهاتف",
      "password": "كلمة المرور",
      "enterPassword": "ادخل كلمة المرور",
      "forgetPassword": "نسيت كلمة المرور",
      "noAccount": "ليس لديك حساب؟",
      "createAccount": "إنشاء حساب",
      "signInBtn": "تسجيل دخول",
    },

    "en": {
      "signInTitle": "Sign In",
      "phoneNumber": "Phone Number",
      "enterPhone": "Enter your phone number",
      "password": "Password",
      "enterPassword": "Enter your password",
      "forgetPassword": "Forgot password?",
      "noAccount": "Don't have an account?",
      "createAccount": "Create account",
      "signInBtn": "Sign In",
    },
  };
}
