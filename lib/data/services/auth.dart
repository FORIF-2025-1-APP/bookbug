import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

Future<bool> login(String email, String password, BuildContext context) async {
  final storage = const FlutterSecureStorage();

  try {
    final response = await http.post(
      Uri.parse('https://forifbookbugapi.seongjinemong.app/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      await storage.write(key: 'auth_token', value: token);

      return true;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error. Please try again.')),
      );
    }
  }

  return false;
}

Future<bool> loginWithGoogle(String idToken, BuildContext context) async {
  final storage = const FlutterSecureStorage();

  try {
    final response = await http.post(
      Uri.parse('https://forifbookbugapi.seongjinemong.app/api/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idToken': idToken}),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      await storage.write(key: 'auth_token', value: token);

      return true;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error. Please try again.')),
      );
    }
  }

  return false;
}

Future<void> logout(BuildContext context) async {
  final storage = const FlutterSecureStorage();
  await storage.delete(key: 'auth_token');
}