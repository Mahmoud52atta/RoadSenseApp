import 'package:flutter/widgets.dart';
import 'package:road_sense_app/core/app_storage.dart';
import 'package:road_sense_app/config/app_config.dart' show getIt;

/// Simple helper to provide English/Arabic strings for auth screens.
/// Uses the app-stored locale (AppStorage) so toggling locale via
/// AppStorage.setLocale(...) will update these strings on rebuild.
class AuthLocalizations {
  final String locale;

  AuthLocalizations(this.locale);

  static AuthLocalizations of(BuildContext context) {
    final code = getIt.get<AppStorage>().getLocale();
    return AuthLocalizations(code);
  }

  bool get isArabic => locale == 'ar';

  String get welcomeBack => isArabic ? 'مرحبا بعودتك' : 'Welcome Back';
  String get signInSubtitle =>
      isArabic ? 'سجل الدخول إلى حسابك' : 'Sign in to your account';

  // Sign Up specific
  String get createAccountTitle => isArabic ? 'إنشاء حساب' : 'Create Account';
  String get signUpSubtitle =>
      isArabic ? 'سجل للحصول على بداية' : 'Sign up to get started';

  String get emailLabel => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get emailHint =>
      isArabic ? 'أدخل عنوان بريدك الإلكتروني' : 'Enter your email address';

  String get nameLabel => isArabic ? 'الاسم' : 'Name';
  String get nameHint => isArabic ? 'أدخل اسمك الكامل' : 'Enter your full name';

  String get phoneLabel => isArabic ? 'رقم الهاتف' : 'Phone Number';
  String get phoneHint =>
      isArabic ? 'أدخل رقم هاتفك' : 'Enter your phone number';

  String get alreadyHaveAccount =>
      isArabic ? 'هل لديك حساب بالفعل؟' : 'Already have an account?';

  String get passwordLabel => isArabic ? 'كلمة المرور' : 'Password';
  String get passwordHint =>
      isArabic ? 'أدخل كلمة المرور' : 'Enter your password';
  String get forgotPassword =>
      isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?';

  String get logIn => isArabic ? 'تسجيل الدخول' : 'Log In';
  String get dontHaveAccount =>
      isArabic ? 'ليس لديك حساب؟' : "Don't have an account?";
  String get signUp => isArabic ? 'إنشاء حساب' : 'Sign Up';
  String get or => isArabic ? 'أو' : 'OR';
  String get continueWithout =>
      isArabic ? 'المتابعة بدون حساب' : 'Continue without account';

  String get SignUpSuccess =>
      isArabic ? 'تم انشاء حساب بنجاح' : 'account created successfully';
}
