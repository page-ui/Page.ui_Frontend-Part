import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/network/network_info.dart';
import 'package:pageui/features/auth/data/data_source/auth_data_source.dart';
import 'package:pageui/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pageui/features/chat/data/data_source/chat_data_source.dart';
import 'package:pageui/features/chat/data/data_source/upload_service.dart';
import 'package:pageui/features/chat/data/repos/chat_repo_impl.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_history_cubit/chat_history_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_home_cubit/chat_home_cubit.dart';
import 'package:pageui/features/chat/presentation/controllers/send_message_cubit/send_message_cubit.dart';

final getit = GetIt.instance;

setUpServiceLocator() {
  // Initialize REST client with refresh token support
  GraphQLConfig.initializeRestClient();

  // ─── Network ────────────────────────────────────────────────────
  getit.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );

  // ─── Auth ───────────────────────────────────────────────────────
  getit.registerLazySingleton<AuthDataSourceImpl>(() => AuthDataSourceImpl());
  getit.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(
      networkInfo: getit.get<NetworkInfo>(),
      dataSource: getit.get<AuthDataSourceImpl>(),
    ),
  );

  // ─── Chat ───────────────────────────────────────────────────────
  getit.registerLazySingleton<ChatDataSource>(() => ChatDataSourceImpl());
  getit.registerLazySingleton<UploadService>(() => UploadService());
  getit.registerLazySingleton<ChatRepo>(
    () => ChatRepoImpl(
      dataSource: getit.get<ChatDataSource>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );

  // Chat cubits — registered as factory so each HomeView gets fresh instances
  getit.registerFactory<ChatHomeCubit>(
    () => ChatHomeCubit(chatRepo: getit.get<ChatRepo>()),
  );
  getit.registerFactory<ChatHistoryCubit>(
    () => ChatHistoryCubit(chatRepo: getit.get<ChatRepo>()),
  );
  getit.registerFactory<SendMessageCubit>(
    () => SendMessageCubit(
      chatRepo: getit.get<ChatRepo>(),
      uploadService: getit.get<UploadService>(),
    ),
  );
}
