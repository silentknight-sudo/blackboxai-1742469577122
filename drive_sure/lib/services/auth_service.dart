import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  // In a real app, this would be your API endpoint
  static const String baseUrl = 'https://api.drivesure.com/auth';
  
  // For demo purposes, we'll simulate API calls
  Future<User> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // final response = await http.post(
    //   Uri.parse('$baseUrl/login'),
    //   body: {'email': email, 'password': password},
    // );

    // For demo, we'll return a mock user if credentials match
    if (email == 'test@example.com' && password == 'password123') {
      return User(
        id: '1',
        email: email,
        name: 'John Doe',
        phone: '+1234567890',
        profilePicture: 'https://i.pravatar.cc/150?img=1',
        createdAt: DateTime.now(),
        favoriteCarIds: [],
        bookingHistory: [],
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<User> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // final response = await http.post(
    //   Uri.parse('$baseUrl/register'),
    //   body: {
    //     'email': email,
    //     'password': password,
    //     'name': name,
    //     'phone': phone,
    //   },
    // );

    // For demo, we'll return a mock user
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      phone: phone,
      createdAt: DateTime.now(),
      favoriteCarIds: [],
      bookingHistory: [],
    );
  }

  Future<void> logout() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // await http.post(Uri.parse('$baseUrl/logout'));
  }

  Future<void> resetPassword(String email) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // await http.post(
    //   Uri.parse('$baseUrl/reset-password'),
    //   body: {'email': email},
    // );
  }

  Future<User> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? profilePicture,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // final response = await http.put(
    //   Uri.parse('$baseUrl/users/$userId'),
    //   body: {
    //     if (name != null) 'name': name,
    //     if (phone != null) 'phone': phone,
    //     if (profilePicture != null) 'profilePicture': profilePicture,
    //   },
    // );

    // For demo, we'll return a mock updated user
    return User(
      id: userId,
      email: 'test@example.com',
      name: name ?? 'John Doe',
      phone: phone ?? '+1234567890',
      profilePicture: profilePicture ?? 'https://i.pravatar.cc/150?img=1',
      createdAt: DateTime.now(),
      favoriteCarIds: [],
      bookingHistory: [],
    );
  }

  Future<User?> getCurrentUser() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // final response = await http.get(Uri.parse('$baseUrl/me'));

    // For demo, we'll return null to simulate no active session
    return null;
  }

  // Helper method to handle HTTP responses
  void _handleResponse(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception(json.decode(response.body)['message'] ?? 'An error occurred');
    }
  }
}