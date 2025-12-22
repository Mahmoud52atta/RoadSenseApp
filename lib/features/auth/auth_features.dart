import 'package:app_features/app_features.dart';
import 'package:road_sense_app/features/auth/actions/domain/repo/auth_repo.dart';
import 'package:road_sense_app/features/auth/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:road_sense_app/features/auth/sign_in_page.dart';
import 'package:road_sense_app/features/auth/pages/sign_up_page.dart';
import '../../config/app_config.dart';

class AuthFeatures extends Feature {
  static AuthFeatures get to => AppFeatures.get();
  @override
  void get dependencies => {
    getIt.registerLazySingleton(() => AuthCubit(getIt<AuthRepo>())),
  };

  @override
  String get name => '/signin';
  String get signUp => '/signup';

  @override
  List<GoRoute> get routes => [
    GoRoute(path: name, name: name, builder: (_, state) => const SignInPage()),
    GoRoute(
      path: signUp,
      name: signUp,
      builder: (_, state) => const SignUpPage(),
    ),
  ];

  void open() => push(name: signUp);
}
