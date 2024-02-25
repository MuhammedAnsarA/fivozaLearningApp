import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import 'package:fivoza_learning/core/common/app/providers/password_provider.dart';
import 'package:fivoza_learning/core/common/widgets/i_field.dart';

class SignUpForm extends HookWidget {
  const SignUpForm({
    super.key,
    required this.emailController,
    required this.fullNameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  final TextEditingController emailController;
  final TextEditingController fullNameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          IField(
            controller: fullNameController,
            hintText: "Full Name",
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 25),
          IField(
            controller: emailController,
            hintText: "Email Address",
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          IField(
            controller: passwordController,
            hintText: "Password",
            obscureText: passwordProvider.passwordVisible,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                passwordProvider.togglePasswordVisibility();
              },
              icon: Icon(
                passwordProvider.passwordVisible
                    ? IconlyLight.hide
                    : IconlyLight.show,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 25),
          IField(
            controller: confirmPasswordController,
            hintText: "Confirm Password",
            keyboardType: TextInputType.visiblePassword,
            overrideValidator: true,
            validator: (value) {
              if (value != passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          )
        ],
      ),
    );
  }
}
