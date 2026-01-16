import 'package:google_sign_in/google_sign_in.dart';
import 'package:cinebond/service/network_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    await _googleSignIn.initialize(); // ✅ parametresiz
    _initialized = true;
  }

  /// 🔐 SADECE GOOGLE TOKEN AL
  Future<GoogleSignInAuthentication?> signInWithGoogle() async {
    try {
      await _ensureInitialized();

      final GoogleSignInAccount account =
          await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'], // ✅ BURADA
      );

      final GoogleSignInAuthentication auth =
          await account.authentication;

      // 🔥 SENİN İSTEDİĞİN ŞEYLER
      print("EMAIL: ${account.email}");
      print("ID TOKEN: ${auth.idToken}");
      //print("ACCESS TOKEN: ${auth.idToken}");

      return auth;
    } on GoogleSignInException catch (e) {
      print(
        'Google Sign-In error '
        'code=${e.code.name} '
        'description=${e.description}',
      );
      rethrow;
    } catch (e) {
      print("Unexpected Google Sign-In error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
