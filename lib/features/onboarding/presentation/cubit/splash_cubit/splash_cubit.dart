import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/core/cache/cache_helper.dart';
import 'package:news/core/cache/cache_keys.dart';
import 'package:news/features/onboarding/presentation/cubit/splash_cubit/splach_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitState());

  Future<void> checkOnboarding() async {
    emit(SplashLoadingState());

    await Future.delayed(const Duration(seconds: 2));

    final onboardingCompleted =
        CacheHelper.getValue(key: CacheKeys.onboardingCompleted) as bool? ??
        false;

    if (onboardingCompleted) {
      emit(SplashShowHomeState());
    } else {
      emit(SplashShowWelcomeState());
    }
  }
}
