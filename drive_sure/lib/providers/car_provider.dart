import 'package:flutter/foundation.dart';
import '../models/car.dart';
import '../services/car_service.dart';

class CarProvider with ChangeNotifier {
  final CarService _carService = CarService();
  
  List<Car> _cars = [];
  bool _isLoading = false;
  String? _error;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCars() async {
    _setLoading(true);
    try {
      final cars = await _carService.fetchCars();
      _setCars(cars);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchCars(String query) async {
    _setLoading(true);
    try {
      final cars = await _carService.searchCars(query);
      _setCars(cars);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterCars({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? transmission,
    String? fuelType,
  }) async {
    _setLoading(true);
    try {
      final cars = await _carService.filterCars(
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        transmission: transmission,
        fuelType: fuelType,
      );
      _setCars(cars);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Car?> getCarById(String id) async {
    try {
      return await _carService.getCarById(id);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  void _setCars(List<Car> cars) {
    _cars = cars;
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

  // Mock data for testing
  void loadMockData() {
    _cars = [
      Car(
        id: '1',
        name: 'Model 3',
        brand: 'Tesla',
        category: 'Electric',
        pricePerDay: 99.99,
        images: [
          'https://images.unsplash.com/photo-1560958089-b8a1929cea89',
          'https://images.unsplash.com/photo-1561731216-c3a4d99437d5',
        ],
        description: 'The Tesla Model 3 is an all-electric four-door sedan with cutting-edge technology and impressive performance.',
        power: 283,
        seats: 5,
        fuelType: 'Electric',
        transmission: 'Automatic',
        topSpeed: 233,
        acceleration: 5.3,
        isAvailable: true,
        rating: 4.8,
        reviewCount: 128,
        features: [
          'Autopilot',
          'Premium Sound System',
          'Glass Roof',
          'Heated Seats',
        ],
      ),
      Car(
        id: '2',
        name: '3 Series',
        brand: 'BMW',
        category: 'Sedan',
        pricePerDay: 89.99,
        images: [
          'https://images.unsplash.com/photo-1555215695-3004980ad54e',
          'https://images.unsplash.com/photo-1559416284-fd9d34b9df56',
        ],
        description: 'The BMW 3 Series is a luxury sedan that combines comfort, performance, and style.',
        power: 255,
        seats: 5,
        fuelType: 'Petrol',
        transmission: 'Automatic',
        topSpeed: 250,
        acceleration: 5.8,
        isAvailable: true,
        rating: 4.7,
        reviewCount: 95,
        features: [
          'Leather Seats',
          'Navigation System',
          'Parking Sensors',
          'Bluetooth',
        ],
      ),
    ];
    notifyListeners();
  }
}