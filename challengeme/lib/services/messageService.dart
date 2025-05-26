import 'dart:convert';
import 'package:challengeme/models/message.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static const String baseUrl = 'http://10.0.2.2:3001/api/message';

  static Future<List<Message>?> getMessages(String fromId, String toId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/?fromID=$fromId&toID=$toId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Message.fromJson(e)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  static Future<Message?> sendMessage(
      String body, String fromId, String toId) async {
    try {
      final url = Uri.parse('$baseUrl/send');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'from': fromId,
          'to': toId,
          'body': body,
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      Message message = Message.fromJson(jsonDecode(response.body));

      return message;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteMessage(String messageId) async {
    try {
      final url = Uri.parse('$baseUrl/$messageId');

      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        print('${response.statusCode} - ${response.body}');
        return false;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
