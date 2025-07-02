import 'package:dio/dio.dart';
import 'dart:convert';
import '../models/openai_models.dart';

class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  /// Generates a text response
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o-mini',
    Map<String, dynamic>? options,
  }) async {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );
      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Streams a text response for real-time chat
  Stream<String> streamChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o-mini',
    Map<String, dynamic>? options,
  }) async* {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          'stream': true,
          if (options != null) ...options,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;
      await for (var chunk in stream) {
        final String data = String.fromCharCodes(chunk);
        final lines = data.split('\n');

        for (var line in lines) {
          if (line.startsWith('data: ')) {
            final jsonData = line.substring(6);
            if (jsonData == '[DONE]') break;

            try {
              final Map<String, dynamic> json =
                  Map<String, dynamic>.from(jsonDecode(jsonData) as Map);
              final delta = json['choices'][0]['delta'] as Map<String, dynamic>;
              final content = delta['content'] ?? '';
              if (content.isNotEmpty) {
                yield content;
              }
            } catch (e) {
              // Skip invalid JSON chunks
              continue;
            }
          }
        }
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }
}