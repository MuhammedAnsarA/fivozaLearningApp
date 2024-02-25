import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivoza_learning/core/common/app/providers/user_provider.dart';
import 'package:fivoza_learning/core/common/widgets/gradiant_background.dart';
import 'package:fivoza_learning/core/common/widgets/rounded_button.dart';
import 'package:fivoza_learning/core/res/fonts.dart';
import 'package:fivoza_learning/core/res/media_res.dart';
import 'package:fivoza_learning/core/utils/core_utils.dart';
import 'package:fivoza_learning/features/auth/data/models/user_model.dart';
import 'package:fivoza_learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fivoza_learning/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fivoza_learning/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:fivoza_learning/features/auth/presentation/widgets/sign_in_form.dart';
import 'package:fivoza_learning/features/dashboard/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignInScreen extends HookWidget {
  const SignInScreen({super.key});

  static const routeName = "/sign-in";

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: MediaRes.authGradientBackground,
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text(
                      "Easy to learn, discover more skills.",
                      style: TextStyle(
                        fontFamily: Fonts.aeonik,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sign in to your account"),
                        Baseline(
                          baseline: 100,
                          baselineType: TextBaseline.alphabetic,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                SignUpScreen.routeName,
                              );
                            },
                            child: const Text("Register account?"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SignInForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ForgotPasswordScreen.routeName);
                          },
                          child: const Text("Forgot password")),
                    ),
                    const SizedBox(height: 30),
                    state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RoundedButton(
                            label: "Sign In",
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              FirebaseAuth.instance.currentUser?.reload();
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      SignInEvent(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      ),
                                    );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
