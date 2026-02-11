import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

class OAuthService {
  static final OAuthService _instance = OAuthService._internal();
  factory OAuthService() => _instance;
  OAuthService._internal();

  final _apiService = ApiService();
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Sign in with Google, send idToken to backend
  Future<AuthResponseDto?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null; // User cancelled

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) throw Exception('Failed to get Google ID token');

      return await _apiService.authenticateWithGoogle(idToken);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Facebook, send accessToken to backend
  Future<AuthResponseDto?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) return null;
      if (result.status != LoginStatus.success) {
        throw Exception(result.message ?? 'Facebook login failed');
      }

      final accessToken = result.accessToken?.tokenString;
      if (accessToken == null) throw Exception('Failed to get Facebook token');

      return await _apiService.authenticateWithFacebook(accessToken);
    } catch (e) {
      rethrow;
    }
  }
}
