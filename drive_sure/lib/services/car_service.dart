import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';

class CarService {
  // In a real app, this would be your API endpoint
  static const String baseUrl = 'https://api.drivesure.com/cars';

  // For demo purposes, we'll simulate API calls with mock data
  Future<List<Car>> fetchCars() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // final response = await http.get(Uri.parse(baseUrl));

    // Return mock data
    return [
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
      Car(
        id: '3',
        name: 'E-Class',
        brand: 'Mercedes-Benz',
        category: 'Luxury',
        pricePerDay: 129.99,
        images: [
          'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8',
          'https://images.unsplash.com/photo-1618843479428-f42f92b066a5',
        ],
        description: 'The Mercedes-Benz E-Class exemplifies luxury, comfort, and sophisticated engineering.',
        power: 295,
        seats: 5,
        fuelType: 'Hybrid',
        transmission: 'Automatic',
        topSpeed: 250,
        acceleration: 5.6,
        isAvailable: true,
        rating: 4.9,
        reviewCount: 87,
        features: [
          'Premium Leather',
          'Panoramic Roof',
          'Burmester Sound',
          'Driver Assistance',
        ],
      ),
    ];
  }

  Future<List<Car>> searchCars(String query) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // final response = await http.get(
    //   Uri.parse('$baseUrl/search?q=$query'),
    // );

    // For demo, filter mock data based on query
    final allCars = await fetchCars();
    final lowercaseQuery = query.toLowerCase();
    
    return allCars.where((car) {
      return car.name.toLowerCase().contains(lowercaseQuery) ||
          car.brand.toLowerCase().contains(lowercaseQuery) ||
          car.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<List<Car>> filterCars({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? transmission,
    String? fuelType,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // final queryParams = {
    //   if (category != null) 'category': category,
    //   if (minPrice != null) 'minPrice': minPrice.toString(),
    //   if (maxPrice != null) 'maxPrice': maxPrice.toString(),
    //   if (transmission != null) 'transmission': transmission,
    //   if (fuelType != null) 'fuelType': fuelType,
    // };
    // final response = await http.get(
    //   Uri.parse('$baseUrl/filter').replace(queryParameters: queryParams),
    // );

    // For demo, filter mock data based on criteria
    final allCars = await fetchCars();
    
    return allCars.where((car) {
      return (category == null || car.category == category) &&
          (minPrice == null || car.pricePerDay >= minPrice) &&
          (maxPrice == null || car.pricePerDay <= maxPrice) &&
          (transmission == null || car.transmission == transmission) &&
          (fuelType == null || car.fuelType == fuelType);
    }).toList();
  }

  Future<Car?> getCarById(String id) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an HTTP request here
    // final response = await http.get(Uri.parse('$baseUrl/$id'));

    // For demo, find car in mock data
    final allCars = await fetchCars();
    return allCars.firstWhere(
      (car) => car.id == id,
      orElse: () => throw Exception('Car not found'),
    );
  }

  // Helper method to handle HTTP responses
  void _handleResponse(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception(json.decode(response.body)['message'] ?? 'An error occurred');
    }
  }
}