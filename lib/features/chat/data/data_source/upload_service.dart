import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/features/chat/data/data_source/chat_data_source.dart';
import 'package:pageui/features/chat/data/models/upload_result_model.dart';
import 'package:pageui/features/chat/domain/params/send_message_params.dart';

class UploadService {
  static const String _presignEndpoint = '/api/Upload/presign';

  final Dio _client;

  UploadService({Dio? client}) : _client = client ?? GraphQLConfig.restClient;

  Future<UploadResultModel> getPresignedUrl(String originalFileName) async {
    final baseUri = Uri.parse(GraphQLConfig.uri);
    final presignUri = baseUri.replace(
      path: _presignEndpoint,
      queryParameters: {'fileName': originalFileName},
    );

    try {
      final response = await _client.get(presignUri.toString());

      if (response.statusCode != 200) {
        throw Exception('Failed to get presigned upload URL');
      }

      return UploadResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      throw Exception('Failed to get presigned upload URL');
    }
  }

  Future<void> uploadBinary({
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
          headers: {
            'Content-Type': contentType,
            'Content-Length': fileBytes.length.toString(),
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to upload file');
      }
    } on DioException {
      throw Exception('Failed to upload file');
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
