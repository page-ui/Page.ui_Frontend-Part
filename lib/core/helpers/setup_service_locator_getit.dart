import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:pageui/core/network/network_info.dart';
import 'package:pageui/features/auth/data/data_source/auth_data_source.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';

final getit = GetIt.instance;

setUpServiceLocator() {
  getit.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(
      networkInfo: getit.get<NetworkInfo>(),
      dataSource: getit.get<AuthDataSourceImpl>(),
    ),
  );

  getit.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnection()),
  );
  getit.registerLazySingleton<AuthDataSourceImpl>(() => AuthDataSourceImpl());
}
