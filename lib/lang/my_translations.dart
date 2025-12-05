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

          // ---------- Home ----------
          "homeHello": "مرحباً",
          "homeReadyTitle": "جاهز لمباراة جديدة؟",
          "homeBookAgain": "احجز مجددًا",
          "homeFootball": "كرة قدم",
          "homeBasketball": "كرة سلة",
          "homeTennis": "كرة مضرب",
          "homeVolleyball": "كرة طائرة",
          "homeActionBook": "احجز ملعب",
          "homeActionTrain": "تدرب",
          "homeActionCompete": "نافس",
          "homeActionSearchMatch": "ابحث عن مباراة",
          "homeReservedMatches": "المباريات المحيطة",
          "homeMore": "المزيد",
          "homeReservedStadiums": "الملاعب المحيطة",
          "availableStadiums": "الملاعب المتاحة",
          "homeExtraOptions": "خيارات إضافية",
          "homeCurrencyPerHour": "ريال / س",
          "homeCoachesNearYou": "مدربون بجوارك",

          // ---------- Profile ----------
          "OldReservations": "حجوزاتي السابقة",
          "TrainingSchedule": "جدول تدريباتي",
          "BankCards": "بطاقاتي البنكية",
          "AboutUs": "من نحن",
          "Privacy": "سياسة الخصوصية",
          "Terms": "شروط الاستخدام",
          "Logout": "تسجيل خروج",

          // ---------- Service Screen ----------
          "serviceMainTitle": "ميدان أنشطتك الرياضية",
          "serviceBookStadiumTitle": "حجز ملعب",
          "serviceBookCoachTitle": "بحث عن مدرب",

          "serviceGridBookStadium": "حجز ملعب",
          "serviceGridCreateMatch": "إنشاء مباراة / تحدي / نشاط",
          "serviceGridCreate2Match": "إنشاء نشاط رياضي",

          "serviceGridChallenges": "التحديات",
          "serviceGridMatches": "المباريات",
          "serviceGridCoaches": "المدربون",
          "serviceGridActivities": "الأنشطة الرياضية",

          // ---------- Match Type Tabs ----------
          "serviceSelectMatchType": "حدد نوع المباراة",
          "serviceMatchTypeMatch": "مباراة",
          "serviceMatchTypeChallenge": "تحدي",
          "serviceMatchTypeActivity": "أنشطة",

          // ---------- Match Reservation ----------
          "matchReservationNotFound": "بيانات المباراة غير متوفرة",
          "matchReservationChoosePlace": "حدد مكانك",
          "matchReservationCompleteBooking": "إتمام الحجز",
          "matchReservationCurrency": "ريال",

          "matchTypeMatch": "مباراة",
          "matchTypeChallenge": "تحدي",
          "matchTypeActivity": "أنشطة",

          // ---------- Booking Success Dialog ----------
          "bookingSuccessTitle": "تم الحجز بنجاح",
          "bookingSuccessDoneBtn": "تم",

          // ---------- Notifications ----------
          "notificationsTitle": "التنبيهات",

          // ---------- Coach Details ----------
          "coachDetailsBookSchedule": "احجز جدولك التدريبي",

          // ---------- Coach Schedule ----------
          "coachScheduleCompleteBooking": "إتمام الحجز",
          "chooseDaysPackage": "اختر باقة الأيام",
          "chooseTrainingHoursFor": "اختر ساعات التدريب ليوم ",

          // ---------- Activity Details ----------
          "subscribe": "اشترك الآن",
          "detailsActivity": "تفاصيل النشاط",
          "countSubscribe": "عدد المشتركين",
          "stadium": "الملعب",
          "size": "المساحة",
          "services": "الخدمات",
          "location": "الموقع",
          "fansStand": "مدرج المشجعين",
          "photoActivity": "صورة توضيحة للنشاط",

          // ---------- Booking Stadium ----------
          "selectDay": "حدد اليوم",
          "selectDayStart": "حدد موعد البداية",
          "selectDayEnd": "حدد موعد النهاية",
          "selectTimeStartEnd": "حدد ساعة البداية وساعة النهاية",
          "aboutStadium": "عن الملعب",
          "pay?": "من سيقوم بالدفع ؟",

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

          // ---------- Home ----------
          "homeHello": "Welcome",
          "homeReadyTitle": "Ready for a new match?",
          "homeBookAgain": "Book again",
          "homeFootball": "Football",
          "homeBasketball": "Basketball",
          "homeTennis": "Tennis",
          "homeVolleyball": "Volleyball",
          "homeActionBook": "Book a pitch",
          "homeActionTrain": "Train",
          "homeActionCompete": "Compete",
          "homeActionSearchMatch": "Find a match",
          "homeReservedMatches": "Reserved matches",
          "homeMore": "More",
          "homeReservedStadiums": "Reserved stadiums",
          "availableStadiums": "Available stadiums",
          "homeExtraOptions": "More options",
          "homeCurrencyPerHour": "SAR / hour",
          "homeCoachesNearYou": "Coaches near you",

          // ---------- Profile ----------
          "OldReservations": "My Previous Bookings",
          "TrainingSchedule": "My Training Schedule",
          "BankCards": "My Bank Cards",
          "AboutUs": "About Us",
          "Privacy": "Privacy Policy",
          "Terms": "Terms of Use",
          "Logout": "Log Out",

          // ---------- Service Screen ----------
          "serviceMainTitle": "Your sports activities hub",
          "serviceBookStadiumTitle": "Book a stadium",
          "serviceBookCoachTitle": "Book a coach",

          "serviceGridBookStadium": "Book stadium",
          "serviceGridCreateMatch": "Create match / challenge / activity",
          "serviceGridCreate2Match": "Creating a sports activity",
          "serviceGridChallenges": "Challenges",
          "serviceGridMatches": "Matches",
          "serviceGridCoaches": "Coaches",
          "serviceGridActivities": "Sports activities",

          // ---------- Match Type Tabs ----------
          "serviceSelectMatchType": "Select match type",
          "serviceMatchTypeMatch": "Match",
          "serviceMatchTypeChallenge": "Challenge",
          "serviceMatchTypeActivity": "Activities",

          // ---------- Match Reservation ----------
          "matchReservationNotFound": "Match data not found",
          "matchReservationChoosePlace": "Choose your spot",
          "matchReservationCompleteBooking": "Complete booking",
          "matchReservationCurrency": "SAR",

          "matchTypeMatch": "Match",
          "matchTypeChallenge": "Challenge",
          "matchTypeActivity": "Activity",

          // ---------- Booking Success Dialog ----------
          "bookingSuccessTitle": "Booking completed successfully",
          "bookingSuccessDoneBtn": "Done",

          // ---------- Notifications ----------
          "notificationsTitle": "Notifications",

          // ---------- Coach Details ----------
          "coachDetailsBookSchedule": "Book your training schedule",

          // ---------- Coach Schedule ----------
          "coachScheduleCompleteBooking": "Complete booking",
          "chooseDaysPackage": "Choose days package",
          "chooseTrainingHoursFor": "Choose training hours for ",

          // ---------- Activity Details ----------
          "subscribe": "Subscribe",
          "detailsActivity": "Details Activity",
          "countSubscribe": "Count Subscribe",
          "stadium": "Stadium",
          "size": "Size",
          "location": "Location",
          "services": "Services",
          "fansStand": "Fans' stand",
          "photoActivity": "Photo For Activity",

          // ---------- Booking Stadium ----------
          "selectDay": "Select Day",
          "selectDayStart": "Select Day Start",
          "selectDayEnd": "Select Day End",
          "selectTimeStartEnd": "Select Hour Start To End",
          "aboutStadium": "About Stadium",
          "pay?": "Who will pay?",

        }
      };
}
