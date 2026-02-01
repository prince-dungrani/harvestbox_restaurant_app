import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_profile.dart';

class ProfileService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE/UPDATE: Save or update user profile
  Future<void> saveProfile(UserProfile profile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _database.child('users').child(userId).set(profile.toJson());
    } catch (e) {
      print('Error saving profile: $e');
      rethrow;
    }
  }

  // READ: Get user profile
  Future<UserProfile?> getProfile(String uid) async {
    try {
      final profileRef = _database.child('users').child(uid);
      final snapshot = await profileRef.get();

      if (!snapshot.exists) return null;

      return UserProfile.fromJson(snapshot.value as Map<dynamic, dynamic>);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // READ: Get current user's profile
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      return await getProfile(userId);
    } catch (e) {
      print('Error fetching current user profile: $e');
      return null;
    }
  }

  // UPDATE: Update specific profile fields
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _database.child('users').child(userId).update(updates);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // DELETE: Delete user profile
  Future<void> deleteProfile(String uid) async {
    try {
      await _database.child('users').child(uid).remove();
    } catch (e) {
      print('Error deleting profile: $e');
      rethrow;
    }
  }

  // Create profile from Firebase Auth user
  Future<void> createProfileFromAuthUser(User user) async {
    try {
      // Check if profile already exists
      final existingProfile = await getProfile(user.uid);
      if (existingProfile != null) return;

      // Create new profile
      final profile = UserProfile(
        uid: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        phone: user.phoneNumber,
        photoUrl: user.photoURL,
        address: null,
        createdAt: DateTime.now(),
      );

      await saveProfile(profile);
    } catch (e) {
      print('Error creating profile from auth user: $e');
      rethrow;
    }
  }

  // Stream of profile changes (real-time updates)
  Stream<UserProfile?> profileStream(String uid) {
    return _database.child('users').child(uid).onValue.map((event) {
      if (!event.snapshot.exists) return null;
      return UserProfile.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
    });
  }
}
