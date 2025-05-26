import 'dart:convert';
import 'package:challengeme/models/user.dart';
import 'package:flutter/material.dart';
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

  Future<List<User>> loadUsers() async {
    final url = Uri.parse('$baseUrl/users');

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      return [];
    }

    final List<dynamic> data = jsonDecode(response.body);
    List<User> users = data.map((u) => User.fromJson(u)).toList();

    return users;
  }

  Future<List<User>> loadSpecialists() async {
    final url = Uri.parse('$baseUrl/specialists');

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      return [];
    }

    final List<dynamic> data = jsonDecode(response.body);
    List<User> users = data.map((u) => User.fromJson(u)).toList();

    return users;
  }

  Future<List<User>> loadTrainees(String specialistId) async {
    try {
      final url = Uri.parse('$baseUrl/inquiries/$specialistId');

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return [];
      }
      final List<dynamic> data = jsonDecode(response.body);
      List<User> users = data.map((u) => User.fromJson(u)).toList();

      return users;
    } catch (e) {
      print('Exception : $e');
      return [];
    }
  }
}
