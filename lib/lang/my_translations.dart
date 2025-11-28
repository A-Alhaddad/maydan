import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "ar": {
      // ---------- Sign In ----------
      "signInTitle": "تسجيل الدخول",
      "phoneNumber": "رقم الهاتف",
      "enterPhone": "أدخل رقم الهاتف",
      "password": "كلمة المرور",
      "enterPassword": "أدخل كلمة المرور",
      "forgetPassword": "نسيت كلمة المرور؟",
      "noAccount": "ليس لديك حساب؟",
      "createAccount": "إنشاء حساب",
      "signInBtn": "تسجيل دخول",

      // ---------- Sign Up ----------
      "signUpTitle": "إنشاء حساب",
      "userName": "اسم المستخدم",
      "enterUserName": "أدخل اسم المستخدم",
      "haveAccount": "لديك حساب؟",
      "signInNow": "تسجيل دخول",
      "continueVerifyBtn": "متابعة للتحقق",

      // ---------- OTP ----------
      "otpTitle": "رمز التحقق",
      "otpSubtitle": "أدخل رمز التحقق الذي وصل إلى جوالك",
      "enterOTP": "أدخل رمز التحقق",
      "didntReceive": "لم يصلك رمز التحقق؟",
      "resend": "إرسال مجددًا",
      "verifyBtn": "تحقق",
      "otpShort": "رمز التحقق غير مكتمل",
      "otpWrong": "رمز التحقق غير صحيح",

      // ---------- Forget Password ----------
      "forgetPasswordTitle": "نسيت كلمة المرور",

      // ---------- Change Password ----------
      "changePasswordTitle": "أدخل كلمة المرور الجديدة",
      "passwordNotMatch": "كلمات المرور غير متطابقة!",
      "passwordTooShort": "يجب أن تكون كلمة المرور لا تقل عن 8 خانات",
      "saveBtn": "حفظ",
    },

    // ======================================================================

    "en": {
      // ---------- Sign In ----------
      "signInTitle": "Sign In",
      "phoneNumber": "Phone Number",
      "enterPhone": "Enter phone number",
      "password": "Password",
      "enterPassword": "Enter password",
      "forgetPassword": "Forgot password?",
      "noAccount": "Don’t have an account?",
      "createAccount": "Create account",
      "signInBtn": "Sign In",

      // ---------- Sign Up ----------
      "signUpTitle": "Sign Up",
      "userName": "Username",
      "enterUserName": "Enter username",
      "haveAccount": "Already have an account?",
      "signInNow": "Sign in",
      "continueVerifyBtn": "Continue to verify",

      // ---------- OTP ----------
      "otpTitle": "Verification Code",
      "otpSubtitle": "Enter the verification code sent to your phone",
      "enterOTP": "Enter verification code",
      "didntReceive": "Didn’t receive the code?",
      "resend": "Resend",
      "verifyBtn": "Verify",
      "otpShort": "Verification code is incomplete",
      "otpWrong": "Verification code is incorrect",

      // ---------- Forget Password ----------
      "forgetPasswordTitle": "Forgot Password",

      // ---------- Change Password ----------
      "changePasswordTitle": "Enter New Password",
      "passwordNotMatch": "Passwords do not match!",
      "passwordTooShort": "Password must be at least 8 characters",
      "saveBtn": "Save",
    }
  };
}
