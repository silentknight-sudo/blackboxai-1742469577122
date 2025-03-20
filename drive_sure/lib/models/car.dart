class Car {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double pricePerDay;
  final List<String> images;
  final String description;
  final int power;
  final int seats;
  final String fuelType;
  final String transmission;
  final int topSpeed;
  final double acceleration;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final List<String> features;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.pricePerDay,
    required this.images,
    required this.description,
    required this.power,
    required this.seats,
    required this.fuelType,
    required this.transmission,
    required this.topSpeed,
    required this.acceleration,
    required this.isAvailable,
    required this.rating,
    required this.reviewCount,
    required this.features,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      description: json['description'] as String,
      power: json['power'] as int,
      seats: json['seats'] as int,
      fuelType: json['fuelType'] as String,
      transmission: json['transmission'] as String,
      topSpeed: json['topSpeed'] as int,
      acceleration: (json['acceleration'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      features: List<String>.from(json['features'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'pricePerDay': pricePerDay,
      'images': images,
      'description': description,
      'power': power,
      'seats': seats,
      'fuelType': fuelType,
      'transmission': transmission,
      'topSpeed': topSpeed,
      'acceleration': acceleration,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'features': features,
    };
  }

  Car copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    double? pricePerDay,
    List<String>? images,
    String? description,
    int? power,
    int? seats,
    String? fuelType,
    String? transmission,
    int? topSpeed,
    double? acceleration,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    List<String>? features,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      images: images ?? this.images,
      description: description ?? this.description,
      power: power ?? this.power,
      seats: seats ?? this.seats,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      topSpeed: topSpeed ?? this.topSpeed,
      acceleration: acceleration ?? this.acceleration,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      features: features ?? this.features,
    );
  }
}