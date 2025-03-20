import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/car_listing.dart';

class CarListingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collection = 'car_listings';

  // Create a new car listing
  Future<CarListing> createCarListing({
    required String ownerId,
    required String make,
    required String model,
    required int year,
    required String category,
    required double pricePerDay,
    required List<File> imageFiles,
    required String description,
    required String location,
    required Map<String, dynamic> specifications,
    required List<String> availableDates,
    required Map<String, dynamic> restrictions,
  }) async {
    try {
      // Upload images to Firebase Storage
      List<String> imageUrls = await Future.wait(
        imageFiles.map((file) => _uploadImage(file)),
      );

      // Create the listing document
      final docRef = await _firestore.collection(_collection).add({
        'ownerId': ownerId,
        'make': make,
        'model': model,
        'year': year,
        'category': category,
        'pricePerDay': pricePerDay,
        'images': imageUrls,
        'description': description,
        'location': location,
        'specifications': specifications,
        'isAvailable': true,
        'createdAt': Timestamp.now(),
        'availableDates': availableDates,
        'restrictions': restrictions,
      });

      // Get the created document
      final doc = await docRef.get();
      return CarListing.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to create car listing: $e');
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('car_listings/$fileName');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get all car listings
  Stream<List<CarListing>> getCarListings() {
    return _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => CarListing.fromFirestore(doc)).toList();
        });
  }

  // Get user's car listings
  Stream<List<CarListing>> getUserCarListings(String userId) {
    return _firestore
        .collection(_collection)
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => CarListing.fromFirestore(doc)).toList();
        });
  }

  // Update car listing
  Future<CarListing> updateCarListing({
    required String listingId,
    String? make,
    String? model,
    int? year,
    String? category,
    double? pricePerDay,
    List<File>? newImageFiles,
    List<String>? existingImageUrls,
    String? description,
    String? location,
    Map<String, dynamic>? specifications,
    bool? isAvailable,
    List<String>? availableDates,
    Map<String, dynamic>? restrictions,
  }) async {
    try {
      final docRef = _firestore.collection(_collection).doc(listingId);
      
      // Upload new images if provided
      List<String> allImageUrls = existingImageUrls ?? [];
      if (newImageFiles != null && newImageFiles.isNotEmpty) {
        final newUrls = await Future.wait(
          newImageFiles.map((file) => _uploadImage(file)),
        );
        allImageUrls.addAll(newUrls);
      }

      // Update the document
      await docRef.update({
        if (make != null) 'make': make,
        if (model != null) 'model': model,
        if (year != null) 'year': year,
        if (category != null) 'category': category,
        if (pricePerDay != null) 'pricePerDay': pricePerDay,
        if (allImageUrls.isNotEmpty) 'images': allImageUrls,
        if (description != null) 'description': description,
        if (location != null) 'location': location,
        if (specifications != null) 'specifications': specifications,
        if (isAvailable != null) 'isAvailable': isAvailable,
        if (availableDates != null) 'availableDates': availableDates,
        if (restrictions != null) 'restrictions': restrictions,
      });

      // Get the updated document
      final doc = await docRef.get();
      return CarListing.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to update car listing: $e');
    }
  }

  // Delete car listing
  Future<void> deleteCarListing(String listingId) async {
    try {
      // Get the listing to get image URLs
      final doc = await _firestore.collection(_collection).doc(listingId).get();
      final listing = CarListing.fromFirestore(doc);

      // Delete images from storage
      await Future.wait(
        listing.images.map((url) => _deleteImage(url)),
      );

      // Delete the document
      await _firestore.collection(_collection).doc(listingId).delete();
    } catch (e) {
      throw Exception('Failed to delete car listing: $e');
    }
  }

  // Delete image from Firebase Storage
  Future<void> _deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  // Search car listings
  Stream<List<CarListing>> searchCarListings({
    String? searchTerm,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? location,
  }) {
    Query query = _firestore.collection(_collection)
        .where('isAvailable', isEqualTo: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    if (minPrice != null) {
      query = query.where('pricePerDay', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      query = query.where('pricePerDay', isLessThanOrEqualTo: maxPrice);
    }

    return query.snapshots().map((snapshot) {
      var listings = snapshot.docs.map((doc) => CarListing.fromFirestore(doc)).toList();

      if (searchTerm != null) {
        final term = searchTerm.toLowerCase();
        listings = listings.where((listing) {
          return listing.make.toLowerCase().contains(term) ||
              listing.model.toLowerCase().contains(term) ||
              listing.description.toLowerCase().contains(term);
        }).toList();
      }

      if (location != null) {
        final loc = location.toLowerCase();
        listings = listings.where((listing) {
          return listing.location.toLowerCase().contains(loc);
        }).toList();
      }

      return listings;
    });
  }
}