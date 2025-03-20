import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _authService.login(email, password);
      _setUser(user);
      _setIsAuthenticated(true);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    _setLoading(true);
    try {
      final user = await _authService.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      _setUser(user);
      _setIsAuthenticated(true);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _setUser(null);
      _setIsAuthenticated(false);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? profilePicture,
  }) async {
    if (_user == null) return;

    _setLoading(true);
    try {
      final updatedUser = await _authService.updateProfile(
        userId: _user!.id,
        name: name,
        phone: phone,
        profilePicture: profilePicture,
      );
      _setUser(updatedUser);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      final user = await _authService.getCurrentUser();
      _setUser(user);
      _setIsAuthenticated(user != null);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      _setUser(null);
      _setIsAuthenticated(false);
    } finally {
      _setLoading(false);
    }
  }

  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setIsAuthenticated(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }

  // Mock data for testing
  void loginWithMockData() {
    _user = User(
      id: '1',
      email: 'test@example.com',
      name: 'John Doe',
      phone: '+1234567890',
      profilePicture: 'https://i.pravatar.cc/150?img=1',
      createdAt: DateTime.now(),
    );
    _isAuthenticated = true;
    notifyListeners();
  }
}