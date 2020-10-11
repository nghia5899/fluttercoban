import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class LoginState{
  final bool isValidEmail;
  final bool isValidPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isValidEmailAndPassword => isValidEmail && isValidPassword;

  LoginState({
    @required this.isValidEmail,
    @required this.isValidPassword,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure
  });
  factory LoginState.iniital(){
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }
  factory LoginState.loading(){
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }
  factory LoginState.failure(){
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }
  factory LoginState.success(){
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }

  //nhân bản đối tượng
  LoginState cloneWith({
    bool isValidEmail,
    bool isValidPassword,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure
  }){
    return LoginState(isValidEmail: isValidEmail ?? this.isValidEmail,
        isValidPassword: isValidPassword  ?? this.isValidPassword,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  //nhân bản rồi cập nhật luôn
  LoginState cloneAndUpdate({bool isValidEmail, bool isValidPassword}){
    return cloneWith(isValidEmail: isValidEmail,isValidPassword: isValidPassword);
  }

}