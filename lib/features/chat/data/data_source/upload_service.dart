import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/features/chat/data/models/upload_result_model.dart';

class UploadService {
  static const String _presignEndpoint = '/api/Upload/presign';

  final Dio _client;

  UploadService({Dio? client}) : _client = client ?? GraphQLConfig.restClient;

  Future<String> upload({
    required Uint8List fileBytes,
    required String fileName,
    required String contentType,
  }) async {
    final presignResult = await _getPresignedUrl(fileName);
    await _uploadBinary(
      uploadUrl: _resolveAgainstBase(presignResult.uploadUrl),
      fileBytes: fileBytes,
      contentType: contentType,
    );
    return _resolveAgainstBase(presignResult.downloadUrl);
  }

  String _resolveAgainstBase(String url) {
    final parsed = Uri.parse(url);
    if (parsed.hasScheme) return url;
    return Uri.parse(GraphQLConfig.uri).resolveUri(parsed).toString();
  }

  Future<UploadResultModel> _getPresignedUrl(String originalFileName) async {
    final baseUri = Uri.parse(GraphQLConfig.uri);
    final presignUri = baseUri.replace(
      path: _presignEndpoint,
      queryParameters: {'fileName': originalFileName},
    );

    try {
      final response = await _client.get(presignUri.toString());

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to get presigned upload URL '
          '(status ${response.statusCode}): ${response.data}',
        );
      }

      return UploadResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Failed to get presigned upload URL: '
        '${e.response?.statusCode} ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<void> _uploadBinary({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  }) async {
    if (uploadUrl.isEmpty) {
      throw Exception('Upload URL cannot be empty');
    }
    if (fileBytes.isEmpty) {
      throw Exception('File bytes cannot be empty');
    }

    try {
      final uploadClient = Dio();
      final response = await uploadClient.put(
        uploadUrl,
        data: fileBytes,
        options: Options(
          contentType: contentType,
          headers: {Headers.contentLengthHeader: fileBytes.length},
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to upload file (PUT $uploadUrl, status '
          '${response.statusCode}): ${response.data}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to upload file (PUT $uploadUrl): '
        '${e.response?.statusCode} ${e.response?.data ?? e.message}',
      );
    }
  }
}
