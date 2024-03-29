import 'package:fivoza_learning/core/extensions/context_extensions.dart';
import 'package:fivoza_learning/core/res/colours.dart';
import 'package:fivoza_learning/core/res/fonts.dart';
import 'package:fivoza_learning/features/onboarding/domain/entities/page_content.dart';
import 'package:fivoza_learning/features/onboarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    super.key,
    required this.pageContent,
  });

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          pageContent.image,
          height: context.height * 0.4,
        ),
        SizedBox(height: context.height * 0.03),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: Fonts.aeonik,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: context.height * 0.02),
              Text(
                pageContent.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: context.height * 0.05),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 17,
                      ),
                      backgroundColor: Colours.primaryColour,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    // TODO(Get-Started) Implement this functionality
                    context.read<OnBoardingCubit>().cacheFirstTimer();

                    /// push them to the appropriate screen
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                        fontFamily: Fonts.aeonik, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
