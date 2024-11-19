// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:busy_bookseller/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:busy_bookseller/onboarding_view/onboarding_page.dart';
import 'package:busy_bookseller/services/mixins/network_mixin.dart';
import 'package:busy_bookseller/settings_view/privacy_view.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> with NetworkMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    super.initState();
  }

  Future<void> _init() async {
    await checkConnection(
      onError: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const InitialScreen()),
      ),
    );

    final isFirstRun = await IsFirstRun.isFirstRun();

    if (isFirstRun) {
      InAppReview.instance.requestReview();
    }

    if (!canNavigate) {
      if (isFirstRun) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CustomNavigationBar(),
          ),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PrivacyView(),
        ),
      );
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
