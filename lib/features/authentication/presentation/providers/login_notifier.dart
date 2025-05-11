import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Represents the different states of the login process.
enum LoginStatus { initial, loading, success, error }

/// Holds the current login state along with an optional error message.
class LoginState {
  final LoginStatus status;
  final String errorMessage;

  LoginState({
    required this.status,
    this.errorMessage = '',
  });

  LoginState copyWith({LoginStatus? status, String? errorMessage}) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// LoginNotifier manages email/password login as well as real Google Sign-In.
class LoginNotifier extends StateNotifier<LoginState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  LoginNotifier(this._firebaseAuth, this._googleSignIn)
      : super(LoginState(status: LoginStatus.initial));

  /// Logs in with email & password using Firebase Auth.
  Future<void> loginWithEmail(String email, String password) async {
    state = state.copyWith(status: LoginStatus.loading);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(status: LoginStatus.success);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.message ?? 'Unknown FirebaseAuth error',
      );
    } catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Logs in with Google using real Google Sign-In integration.
  Future<void> loginWithGoogle() async {
    state = state.copyWith(status: LoginStatus.loading);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      log("##DEV===>GoogleSignInAccount ==>$googleUser");
      if (googleUser == null) {
        state = state.copyWith(
          status: LoginStatus.error,
          errorMessage: 'Google Sign-In was cancelled.',
        );
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      state = state.copyWith(status: LoginStatus.success);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.message ?? 'Unknown Google Auth error',
      );
    } catch (e) {
      log("##DEV===>GoogleSignInAccount catch==>${e.toString()}");
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

/// Provider for FirebaseAuth instance.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// Provider for GoogleSignIn instance.
final googleSignInProvider = Provider<GoogleSignIn>(
      (ref) => GoogleSignIn(scopes: ['email']),
);

/// Exposes the LoginNotifier and LoginState to the UI.
final loginNotifierProvider =
StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return LoginNotifier(auth, googleSignIn);
});
