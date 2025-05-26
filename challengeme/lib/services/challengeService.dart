import 'dart:convert';
import 'package:challengeme/models/challenge.dart';
import 'package:challengeme/models/user.dart';
import 'package:http/http.dart' as http;

class ChallengeService {
  static const String baseUrl = 'http://10.0.2.2:3001/api/challenge';

  static Future<List<Challenge>?> getFromChallenges(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/from/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Challenge.fromJson(e)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false as dynamic;
      }
    } catch (e) {
      print('Exception: $e');
      return false as dynamic;
    }
  }

  static Future<List<Challenge>?> getToChallenges(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/to/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Challenge.fromJson(e)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false as dynamic;
      }
    } catch (e) {
      print('Exception: $e');
      return false as dynamic;
    }
  }

  Future<Challenge?> createChallenge(
      String title, String des, String from, String to, String deadline) async {
    try {
      final url = Uri.parse('$baseUrl/create');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'deadline': deadline,
          'from': from,
          'to': to,
          'description': des
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      print(jsonDecode(response.body));
      Challenge challenge = Challenge.fromJson(jsonDecode(response.body));

      return challenge;
    } catch (e) {
      print('Trying');
      return null;
    }
  }

  Future<User?> completeChallenge(String challengeId) async {
    try {
      final url = Uri.parse('$baseUrl/complete/$challengeId');

      final response =
          await http.post(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 200) {
        return null;
      }

      print(jsonDecode(response.body));

      User user = User.fromJson(jsonDecode(response.body));

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
