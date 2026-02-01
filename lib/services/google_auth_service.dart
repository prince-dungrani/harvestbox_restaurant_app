import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'profile_service.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final ProfileService _profileService = ProfileService();

  Future<User?> signInWithGoogle() async {
    try {
      // Check if user is already signed in to Google
      final GoogleSignInAccount? currentUser = await _googleSignIn
          .signInSilently();

      // If not signed in silently, show account picker
      final GoogleSignInAccount? googleUser =
          currentUser ?? await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled login
        print("Google Sign-In: User cancelled");
        return null;
      }

      print("Google Sign-In: User selected: ${googleUser.email}");

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("Google Sign-In: Got authentication tokens");

      // Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("Google Sign-In: Created Firebase credential");

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      print(
        "Google Sign-In: Successfully signed in to Firebase - ${userCredential.user?.email}",
      );

      // Create user profile in Firebase Realtime Database
      if (userCredential.user != null) {
        await _profileService.createProfileFromAuthUser(userCredential.user!);
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");

      // If token expired, try to sign out and sign in again
      if (e.code == 'invalid-credential' || e.code == 'user-disabled') {
        await _googleSignIn.signOut();
        await _auth.signOut();
      }

      throw Exception("Firebase Authentication failed: ${e.message}");
    } catch (e) {
      print("Google Sign-In Error: $e");
      throw Exception("Google Sign-In failed: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print("Successfully signed out");
    } catch (e) {
      print("Sign out error: $e");
    }
  }

  // Check if user is currently authenticated
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get auth state stream for monitoring login status
  Stream<User?> getAuthStateChanges() {
    return _auth.authStateChanges();
  }
}
