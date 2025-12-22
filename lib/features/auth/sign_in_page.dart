import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_sense_app/config/app_config.dart';
import 'package:road_sense_app/core/app_storage.dart';
import 'package:road_sense_app/core/extensions/context_extension.dart';
import 'package:road_sense_app/core/localization/auth_localization.dart';
import 'package:road_sense_app/features/auth/auth_features.dart';
import 'package:road_sense_app/features/auth/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:road_sense_app/features/home/home_feature.dart';
import 'pages/widgets/auth_text_field.dart';
import 'pages/widgets/primary_button.dart';
import 'pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  late String email, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthCubit.to.SignIn(email: email, password: password);
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryText = Theme.of(context).colorScheme.onBackground;
    final Color secondaryText = primaryText.withOpacity(0.7);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              if (getIt.get<AppStorage>().getLocale() == 'ar') {
                getIt.get<AppStorage>().setLocale('en');
              } else {
                getIt.get<AppStorage>().setLocale('ar');
              }
            },
          ),
          IconButton(
            icon: Icon(
              getIt.get<AppStorage>().getThemeMode() == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              if (getIt.get<AppStorage>().getThemeMode() == ThemeMode.light) {
                getIt.get<AppStorage>().setThemeMode(ThemeMode.dark);
              } else {
                getIt.get<AppStorage>().setThemeMode(ThemeMode.light);
              }
              setState(() {});
            },
          ),
        ],
      ),
      // Dark background with subtle left teal gradient to match design
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(color: Color(0xFF070707)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Card container centered
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // Top icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF122426),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.directions_car_rounded,
                              color: Color(0xFF00BCD4),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            AuthLocalizations.of(context).welcomeBack,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: primaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AuthLocalizations.of(context).signInSubtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF00BCD4),
                                  fontSize: 14,
                                ),
                          ),
                          const SizedBox(height: 20),
                          // The rounded inner panel
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F1518),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              autovalidateMode: _autoValidateMode,
                              child: BlocConsumer<AuthCubit, AuthState>(
                                bloc: AuthCubit.to,
                                listener: (context, state) {
                                  if (state is AuthSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.amber,
                                        content: Text(
                                          AuthLocalizations.of(
                                            context,
                                          ).SignUpSuccess,
                                        ),
                                      ),
                                    );
                                    HomeFeature.to.push();
                                  } else if (state is AuthFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(state.message),
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AuthTextField(
                                        onSaved: (value) => email = value ?? '',
                                        label: AuthLocalizations.of(
                                          context,
                                        ).emailLabel,
                                        hint: AuthLocalizations.of(
                                          context,
                                        ).emailHint,
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (v) {
                                          if (v == null || v.isEmpty)
                                            return 'Please enter email';
                                          if (!RegExp(
                                            r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}",
                                          ).hasMatch(v))
                                            return 'Enter valid email';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 14),
                                      AuthTextField(
                                        onSaved: (value) =>
                                            password = value ?? '',
                                        label: AuthLocalizations.of(
                                          context,
                                        ).passwordLabel,
                                        hint: AuthLocalizations.of(
                                          context,
                                        ).passwordHint,
                                        controller: _passwordController,
                                        obscureText: _obscure,
                                        suffix: IconButton(
                                          onPressed: () => setState(
                                            () => _obscure = !_obscure,
                                          ),
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.isEmpty)
                                            return 'Please enter password';
                                          if (v.length < 6)
                                            return 'Minimum 6 characters';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            AuthLocalizations.of(
                                              context,
                                            ).forgotPassword,
                                            style: const TextStyle(
                                              color: Color(0xFF00BCD4),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      PrimaryButton(
                                        text: AuthLocalizations.of(
                                          context,
                                        ).logIn,
                                        onPressed: _submit,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Sign up link
                          RichText(
                            text: TextSpan(
                              text:
                                  AuthLocalizations.of(
                                    context,
                                  ).dontHaveAccount +
                                  ' ',
                              style: TextStyle(color: secondaryText),
                              children: [
                                TextSpan(
                                  text: AuthLocalizations.of(context).signUp,
                                  style: const TextStyle(
                                    color: Color(0xFF00BCD4),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      AuthFeatures.to.open();
                                    },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          // OR divider and continue without account
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white12,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Text(
                                  AuthLocalizations.of(context).or,
                                  style: TextStyle(color: secondaryText),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              AuthLocalizations.of(context).continueWithout,
                              style: TextStyle(color: secondaryText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
