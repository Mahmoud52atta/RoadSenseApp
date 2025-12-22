import 'package:app_features/app_features.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:road_sense_app/core/services/firebase_auth_service.dart';
import 'package:road_sense_app/features/auth/actions/data/repos/auth_repo_impl.dart';
import 'package:road_sense_app/features/auth/actions/domain/repo/auth_repo.dart';
import 'package:road_sense_app/features/auth/auth_features.dart';
import 'package:road_sense_app/firebase_options.dart';
import '../app/app_feature.dart';
import '../core/app_storage.dart';
import '../features/home/home_feature.dart';
import '../features/splash/pages/splash_feature.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());

  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(firebaseAuthService: getIt<FirebaseAuthService>()),
  );
}

class AppConfig {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Register app-wide dependencies
    setUp();
    await AppStorage.init();

    AppFeatures.config(
      features: [AppFeature(), HomeFeature(), SplashFeature(), AuthFeatures()],
    );
  }
}
