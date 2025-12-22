import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:road_sense_app/config/app_config.dart';
import 'package:road_sense_app/core/app_storage.dart';
import 'package:road_sense_app/core/extensions/context_extension.dart';
import 'package:road_sense_app/core/localization/auth_localization.dart';
import 'package:road_sense_app/features/auth/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/primary_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late String? name, phone, email, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
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
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthCubit.to.signUp(
        email: email!,
        password: password!,
        name: name!,
        phone: phone!,
      );
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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(color: Color(0xFF070707)),
        child: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            bloc: AuthCubit.to,
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.amber,
                    content: Text(AuthLocalizations.of(context).SignUpSuccess),
                  ),
                );
                Navigator.of(context).pop();
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
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
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
                                AuthLocalizations.of(
                                  context,
                                ).createAccountTitle,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: primaryText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AuthLocalizations.of(context).signUpSubtitle,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFF00BCD4),
                                      fontSize: 14,
                                    ),
                              ),
                              const SizedBox(height: 20),
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
                                  child: ModalProgressHUD(
                                    inAsyncCall: state is AuthLoading,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        AuthTextField(
                                          onSaved: (value) {
                                            return name = value;
                                          },
                                          label: AuthLocalizations.of(
                                            context,
                                          ).nameLabel,
                                          hint: AuthLocalizations.of(
                                            context,
                                          ).nameHint,
                                          controller: _nameController,
                                          validator: (v) {
                                            if (v == null || v.isEmpty)
                                              return 'Please enter name';
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        AuthTextField(
                                          onSaved: (value) {
                                            return phone = value;
                                          },
                                          label: AuthLocalizations.of(
                                            context,
                                          ).phoneLabel,
                                          hint: AuthLocalizations.of(
                                            context,
                                          ).phoneHint,
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          validator: (v) {
                                            if (v == null || v.isEmpty)
                                              return 'Please enter phone';
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        AuthTextField(
                                          onSaved: (value) {
                                            return email = value;
                                          },
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
                                        const SizedBox(height: 12),
                                        AuthTextField(
                                          onSaved: (value) {
                                            return password = value;
                                          },
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
                                              color: secondaryText,
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
                                        const SizedBox(height: 18),
                                        PrimaryButton(
                                          text: AuthLocalizations.of(
                                            context,
                                          ).signUp,
                                          onPressed: _submit,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                text: TextSpan(
                                  text:
                                      AuthLocalizations.of(
                                        context,
                                      ).alreadyHaveAccount +
                                      ' ',
                                  style: TextStyle(color: secondaryText),
                                  children: [
                                    TextSpan(
                                      text: AuthLocalizations.of(context).logIn,
                                      style: const TextStyle(
                                        color: Color(0xFF00BCD4),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).pop();
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
