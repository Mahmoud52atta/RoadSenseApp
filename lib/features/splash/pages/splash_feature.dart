import 'package:app_features/app_features.dart';
import 'package:road_sense_app/features/splash/pages/splash_view.dart';
import '../bloc/splash_bloc.dart';
import '../../../config/app_config.dart';
import '../splash_page_rev.dart';

class SplashFeature extends Feature {
  @override
  void get dependencies => {getIt.registerLazySingleton(() => SplashBloc())};
  @override
  String get name => '/';

  @override
  List<GoRoute> get routes => [
    GoRoute(path: name, name: name, builder: (_, state) => const SplashView()),
  ];
}
