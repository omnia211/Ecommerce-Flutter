import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState{}
class AuthInitial extends AuthState{}
class AuthLoading extends AuthState{}
class AuthSuccess extends AuthState{
  User? user;
  AuthSuccess({this.user});
}
class AuthFailure extends AuthState{
  final String errorMessage;
  AuthFailure(this.errorMessage);
}