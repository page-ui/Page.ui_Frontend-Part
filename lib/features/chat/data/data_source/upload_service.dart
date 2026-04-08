import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/features/chat/data/data_source/chat_data_source.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';

class UploadResult {
  final String uploadUrl;
  final String downloadUrl;
  final String fileName;

  UploadResult({
    required this.uploadUrl,
    required this.downloadUrl,
    required this.fileName,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      uploadUrl: json['uploadUrl'] as String,
      downloadUrl: json['downloadUrl'] as String,
      fileName: json['fileName'] as String,
    );
  }
}

class UploadService {
  static const String _presignEndpoint = '/api/Upload/presign';

  final Dio _client;

  UploadService({Dio? client}) : _client = client ?? GraphQLConfig.restClient;

  Future<UploadResult> getPresignedUrl(String originalFileName) async {
    final baseUri = Uri.parse(GraphQLConfig.uri);
    final presignUri = baseUri.replace(
      path: _presignEndpoint,
      queryParameters: {'fileName': originalFileName},
    );

    try {
      final response = await _client.get(presignUri.toString());

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to get presigned upload URL (Status: ${response.statusCode})',
        );
      }

      return UploadResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to get presigned upload URL: ${e.message}');
    }
  }

  Future<void> uploadBinary({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  }) async {
    try {
      // Use a fresh Dio instance to avoid sending the Authorization header
      // from the restClient interceptor, which causes a 400 Bad Request
      // when interacting with presigned S3 URLs.
      final uploadClient = Dio();
      final response = await uploadClient.put(
        uploadUrl,
        data: fileBytes,
        options: Options(
          headers: {
            'Content-Type': contentType,
            'Content-Length': fileBytes.length.toString(),
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to upload file (Status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to upload file: ${e.message}');
    }
  }

  Future<void> sendImageMessage({
    required String chatId,
    required String downloadUrl,
    String content = 'image',
  }) async {
    final params = SendMessageParams(
      chatId: chatId,
      content: content,
      attachmentUrl: downloadUrl,
    );

    final dataSource = ChatDataSourceImpl();
    await dataSource.sendMessage(params: params);
  }

  Future<void> uploadAndSendImage({
    required Uint8List fileBytes,
    required String fileName,
    required String contentType,
    required String chatId,
  }) async {
    final presignResult = await getPresignedUrl(fileName);
    await uploadBinary(
      uploadUrl: presignResult.uploadUrl,
      fileBytes: fileBytes,
      contentType: contentType,
    );
    await sendImageMessage(
      chatId: chatId,
      downloadUrl: presignResult.downloadUrl,
    );
  }
}
