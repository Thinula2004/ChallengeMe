import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3001/api/user';

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    print('POST to $url with $email $password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return response;
  }

  Future<http.Response> signup(
      String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/create');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return response;
  }
}
