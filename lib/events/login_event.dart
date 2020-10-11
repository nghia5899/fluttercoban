import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
  @override
  List<Object> get props => [];
}
class LoginEventEmailChanged extends LoginEvent{
  final String email;
  const LoginEventEmailChanged({this.email});
  @override
    List<Object> get props => [email];
  @override
  String toString() {
    // TODO: implement toString
    return 'Email changed: $email';
  }
}
class LoginEventPassWordChanged extends LoginEvent{
  final String password;
  const LoginEventPassWordChanged({this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() {
    return 'Password changed: $password';
  }
}
class LoginEventWithGooglePressed extends LoginEvent{}
class LoginEventWithEmailAndPasswordPressed extends LoginEvent{
  final String email;
  final String password;
  const LoginEventWithEmailAndPasswordPressed({@required this.email,@required this.password});
  @override
  List<Object> get props => [email,password];
  @override
  String toString() {
    // TODO: implement toString
    return 'LoginEventWithEmailAndPasswordPressed: email=$email, password=$password';
  }
}
