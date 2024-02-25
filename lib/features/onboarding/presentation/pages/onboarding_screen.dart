import 'package:fivoza_learning/core/common/pages/loading_views.dart';
import 'package:fivoza_learning/core/common/widgets/gradiant_background.dart';
import 'package:fivoza_learning/core/res/colours.dart';
import 'package:fivoza_learning/core/res/media_res.dart';
import 'package:fivoza_learning/features/onboarding/domain/entities/page_content.dart';
import 'package:fivoza_learning/features/onboarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:fivoza_learning/features/onboarding/presentation/widgets/onboarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: GradientBackground(
        image: MediaRes.onBoardingBackground,
        child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
          listener: (context, state) {
            if (state is OnBoardingStatus && !state.isFirstTimer) {
              Navigator.pushReplacementNamed(context, "/home");
            } else if (state is UserCached) {
              Navigator.pushReplacementNamed(context, "/");
            }
          },
          builder: (context, state) {
            if (state is CheckingIfUserIsFirstTimer ||
                state is CachingFirstTimer) {
              return const LoadingView();
            }
            return Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: const [
                    OnBoardingBody(pageContent: PageContent.first()),
                    OnBoardingBody(pageContent: PageContent.second()),
                    OnBoardingBody(pageContent: PageContent.third()),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, 0.04),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    onDotClicked: (index) {
                      pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: Colours.primaryColour,
                      dotColor: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


  // @override
  // void initState() {
  //   super.initState();
  //   context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  // }
