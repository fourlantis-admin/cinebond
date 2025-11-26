import 'package:google_sign_in/google_sign_in.dart';
import 'package:cinebond/service/network_manager.dart';

class GoogleAuthService {
  NetworkManager networkManager = NetworkManager();
  final _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  AuthService() {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  /// Always check Google sign in initialization before use
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<GoogleSignInAccount> signInWithGoogle() async {
  await _ensureGoogleSignInInitialized();
  try {
    // authenticate() throws exceptions instead of returning null
    final GoogleSignInAccount account = await _googleSignIn.authenticate(
      scopeHint: ['email'],  // Specify required scopes
    );
    return account;
  } on GoogleSignInException catch (e) {
    print('Google Sign In error: code: ${e. code.name} description:${e.description} details:${e.details}, error: e');
    rethrow;
  } catch (error) {
    print('Unexpected Google Sign-In error: $error');
    rethrow;
  }
}
  
  
}