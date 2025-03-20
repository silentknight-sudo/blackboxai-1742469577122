import 'package:cloud_firestore/cloud_firestore.dart';

class CarListing {
  final String id;
  final String ownerId;
  final String make;
  final String model;
  final int year;
  final String category;
  final double pricePerDay;
  final List<String> images;
  final String description;
  final String location;
  final Map<String, dynamic> specifications;
  final bool isAvailable;
  final DateTime createdAt;
  final List<String> availableDates;
  final Map<String, dynamic> restrictions;
  final DocumentReference? documentReference;

  CarListing({
    required this.id,
    required this.ownerId,
    required this.make,
    required this.model,
    required this.year,
    required this.category,
    required this.pricePerDay,
    required this.images,
    required this.description,
    required this.location,
    required this.specifications,
    required this.isAvailable,
    required this.createdAt,
    required this.availableDates,
    required this.restrictions,
    this.documentReference,
  });

  factory CarListing.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarListing(
      id: doc.id,
      ownerId: data['ownerId'] as String,
      make: data['make'] as String,
      model: data['model'] as String,
      year: data['year'] as int,
      category: data['category'] as String,
      pricePerDay: (data['pricePerDay'] as num).toDouble(),
      images: List<String>.from(data['images'] as List),
      description: data['description'] as String,
      location: data['location'] as String,
      specifications: data['specifications'] as Map<String, dynamic>,
      isAvailable: data['isAvailable'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      availableDates: List<String>.from(data['availableDates'] as List),
      restrictions: data['restrictions'] as Map<String, dynamic>,
      documentReference: doc.reference,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'make': make,
      'model': model,
      'year': year,
      'category': category,
      'pricePerDay': pricePerDay,
      'images': images,
      'description': description,
      'location': location,
      'specifications': specifications,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
      'availableDates': availableDates,
      'restrictions': restrictions,
    };
  }

  CarListing copyWith({
    String? id,
    String? ownerId,
    String? make,
    String? model,
    int? year,
    String? category,
    double? pricePerDay,
    List<String>? images,
    String? description,
    String? location,
    Map<String, dynamic>? specifications,
    bool? isAvailable,
    DateTime? createdAt,
    List<String>? availableDates,
    Map<String, dynamic>? restrictions,
    DocumentReference? documentReference,
  }) {
    return CarListing(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      category: category ?? this.category,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      images: images ?? this.images,
      description: description ?? this.description,
      location: location ?? this.location,
      specifications: specifications ?? this.specifications,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      availableDates: availableDates ?? this.availableDates,
      restrictions: restrictions ?? this.restrictions,
      documentReference: documentReference ?? this.documentReference,
    );
  }
}