import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip.dart';
import '../utils/constants.dart';

class StorageService {
  static Future<void> saveTrip(Trip trip) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trips = await getSavedTrips();
      
      // Check if trip already exists
      final index = trips.indexWhere((t) => t.id == trip.id);
      if (index != -1) {
        trips[index] = trip.copyWith(updatedAt: DateTime.now());
      } else {
        trips.add(trip);
      }

      final tripsJson = trips.map((t) => json.encode(t.toJson())).toList();
      await prefs.setStringList(AppConstants.storageKeyTrips, tripsJson);
    } catch (e) {
      throw Exception('Failed to save trip: $e');
    }
  }

  static Future<List<Trip>> getSavedTrips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tripsJson = prefs.getStringList(AppConstants.storageKeyTrips) ?? [];
      
      return tripsJson
          .map((jsonStr) => Trip.fromJson(json.decode(jsonStr)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> deleteTrip(String tripId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trips = await getSavedTrips();
      trips.removeWhere((t) => t.id == tripId);
      
      final tripsJson = trips.map((t) => json.encode(t.toJson())).toList();
      await prefs.setStringList(AppConstants.storageKeyTrips, tripsJson);
    } catch (e) {
      throw Exception('Failed to delete trip: $e');
    }
  }

  static Future<Trip?> getTripById(String tripId) async {
    try {
      final trips = await getSavedTrips();
      return trips.firstWhere(
        (t) => t.id == tripId,
        orElse: () => throw Exception('Trip not found'),
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.storageKeyUser, json.encode(userData));
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = prefs.getString(AppConstants.storageKeyUser);
      if (userDataJson != null) {
        return json.decode(userDataJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}


