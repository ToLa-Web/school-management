import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tamdansers/services/api_models.dart';
import 'package:tamdansers/services/api_service.dart';

class OAuthService {
  static final OAuthService _instance = OAuthService._internal();
  factory OAuthService() => _instance;
  OAuthService._internal();

  final _apiService = ApiService();

  // FIX: Access the singleton instance
  final _googleSignIn = GoogleSignIn.instance;

  // set up the Google Sign-In plugin (required once before calling signIn)
  Future<void> initializeGoogle() async {
    await _googleSignIn.initialize(
      serverClientId:
          const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'),
    );
  }

  // open the Google sign-in dialog, get the ID token, send it to our backend
  Future<AuthResponseDto?> signInWithGoogle() async {
    try {
      await initializeGoogle();
      final account = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // In v7+, 'authentication' is a synchronous getter
      final auth = account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) throw Exception('Failed to get Google ID token');

      return await _apiService.authenticateWithGoogle(idToken);
    } catch (e) {
      // Users cancelling will throw a GoogleSignInException
      rethrow;
    }
  }

  // open the Facebook login dialog, get the access token, send it to our backend
  Future<AuthResponseDto?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) return null;
      if (result.status != LoginStatus.success) {
        throw Exception(result.message ?? 'Facebook login failed');
      }

      final token = result.accessToken;
      if (token == null) throw Exception('Failed to get Facebook token');

      // flutter_facebook_auth v7: tokenString is on classic (non-limited) tokens
      final tokenString = token.tokenString;
      if (tokenString.isEmpty) throw Exception('Facebook token is empty');

      return await _apiService.authenticateWithFacebook(tokenString);
    } catch (e) {
      rethrow;
    }
  }
}
