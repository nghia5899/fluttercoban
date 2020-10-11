import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RegisterEvent extends Equatable{
  const RegisterEvent();
  @override
  List<Object> get props => [];
}
class RegisterEventEmailChanged extends RegisterEvent{
  final String email;
  const RegisterEventEmailChanged({this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() {
    return 'RegisterEventchanged:{ $email}';
  }
}
class RegisterEventPassWordChanged extends RegisterEvent{
  final String password;
  const RegisterEventPassWordChanged({@required this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() {
    return 'Passwordchanged:{password: $password}';
  }
}
class RegisterEventPressed extends RegisterEvent{
  final String email;
  final String password;
  const RegisterEventPressed({@required this.email,@required this.password});

  @override
  // TODO: implement props
  List<Object> get props => [email,password];
  @override
  String toString() => 'RegisterEventPressed, email:$email,password:$password';
}

