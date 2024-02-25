import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivoza_learning/core/common/app/providers/user_provider.dart';
import 'package:fivoza_learning/core/common/widgets/gradiant_background.dart';
import 'package:fivoza_learning/core/common/widgets/rounded_button.dart';
import 'package:fivoza_learning/core/res/fonts.dart';
import 'package:fivoza_learning/core/res/media_res.dart';
import 'package:fivoza_learning/core/utils/core_utils.dart';
import 'package:fivoza_learning/features/auth/data/models/user_model.dart';
import 'package:fivoza_learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fivoza_learning/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:fivoza_learning/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:fivoza_learning/features/dashboard/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignUpScreen extends HookWidget {
  const SignUpScreen({super.key});

  static const routeName = "/sign-up";

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final fullNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedUp) {
            context.read<AuthBloc>().add(SignInEvent(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                ));
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
                    const Text("Sign up for an account"),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignInScreen.routeName,
                          );
                        },
                        child: const Text("Already have an account?"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SignUpForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      fullNameController: fullNameController,
                      confirmPasswordController: confirmPasswordController,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 30),
                    state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RoundedButton(
                            label: "Sign Up",
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              FirebaseAuth.instance.currentUser?.reload();
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      SignUpEvent(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        name: fullNameController.text.trim(),
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
