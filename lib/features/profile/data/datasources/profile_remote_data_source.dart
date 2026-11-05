import 'package:graphql_flutter/graphql_flutter.dart' hide ServerException;
import 'package:page_ui/core/database/api/graph_ql_config.dart';
import 'package:page_ui/core/errors/app_operation.dart';
import 'package:page_ui/core/errors/exceptions.dart';
import 'package:page_ui/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile({
    required String name,
    String? birthdate,
    String? photoUrl,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  GraphQLClient get _client => GraphQLConfig.client.value;

  static const String getUserProfileQuery = r'''
    query GetUserProfile {
      me {
        id
        name
        birthdate
        photoUrl
      }
    }
  ''';

  static const String updateUserProfileMutation = r'''
    mutation UpdateUserProfile($name: String!, $birthdate: String, $photoUrl: String) {
      updateUserProfile(input: { name: $name, birthdate: $birthdate, photoUrl: $photoUrl }) {
        id
        name
        birthdate
        photoUrl
      }
    }
  ''';

  @override
  Future<UserProfileModel> getUserProfile() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(getUserProfileQuery),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException || result.data?['me'] == null) {
      throw ServerException.fromGraphQL(
        result.exception,
        operation: AppOperation.generic,
      );
    }

    return UserProfileModel.fromJson(result.data!['me'] as Map<String, dynamic>);
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    required String name,
    String? birthdate,
    String? photoUrl,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(updateUserProfileMutation),
        variables: {
          'name': name,
          'birthdate': birthdate,
          'photoUrl': photoUrl,
        },
      ),
    );

    if (result.hasException || result.data?['updateUserProfile'] == null) {
      throw ServerException.fromGraphQL(
        result.exception,
        operation: AppOperation.generic,
      );
    }

    return UserProfileModel.fromJson(
      result.data!['updateUserProfile'] as Map<String, dynamic>,
    );
  }
}
