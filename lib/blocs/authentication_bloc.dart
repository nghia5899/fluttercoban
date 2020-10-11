import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_bloc/events/authentication_event.dart';
import 'package:firebase_login_bloc/repositories/user_repository.dart';
import 'package:firebase_login_bloc/states/authentication_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent,AuthenticationState>{

  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository}):
      assert(userRepository != null),
      _userRepository = userRepository, super(AuthenticationStateInitial());



  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent authenticationEvent) async*{
      if(authenticationEvent is AuthenticationEventStarted){
      final isSignedIn = await _userRepository.isSignIn();
      if(isSignedIn){
        final firebaseUser = await _userRepository.getUser();
        yield AuthenticationStateSuccess(firebaseUser: firebaseUser);
      }else{
        yield AuthenticationStateFailure();
      }
    }else if(authenticationEvent is AuthenticationEventLoggedIn){
      yield AuthenticationStateSuccess(firebaseUser: await _userRepository.getUser());
    }else if(authenticationEvent is AuthenticationEventLoggedOut){
      _userRepository.signOut();
      yield AuthenticationStateFailure();
    }
  }

}