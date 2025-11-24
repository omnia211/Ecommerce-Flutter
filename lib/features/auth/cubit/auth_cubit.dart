import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/firebase_auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // ----------------------
  // LOGIN
  // ----------------------
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      User? user = await FirebaseAuthService.instance.login(email, password);
      emit(AuthSuccess(user: user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Failed to sign in'));
    }
  }

  // ----------------------
  // REGISTER (NEW)
  // ----------------------
  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      User? user = await FirebaseAuthService.instance.register(email, password);
      emit(AuthSuccess(user: user));
    } on FirebaseAuthException catch (e) {
      // معالجة الأخطاء
      String error = "";

      if (e.code == "email-already-in-use") {
        error = "This email is already registered";
      }
      else if (e.code == "weak-password") {
        error = "Password is too weak";
      }
      else {
        error = e.message ?? "Registration failed";
      }

      emit(AuthFailure(error));
    }
  }
}
