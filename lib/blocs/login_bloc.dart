import 'package:firebase_login_bloc/events/login_event.dart';
import 'package:firebase_login_bloc/repositories/user_repository.dart';
import 'package:firebase_login_bloc/states/login_state.dart';
import 'package:firebase_login_bloc/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_login_bloc/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
class LoginBloc extends Bloc<LoginEvent,LoginState>{
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository}):
      assert(userRepository!=null),
      _userRepository = userRepository, super(LoginState.iniital());

  //khoang tre giua 2 lan an
  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(Stream<LoginEvent> loginevents, transitionFn) {
    final debounceStream = loginevents.where((loginevents) {
      return (loginevents is LoginEventEmailChanged || loginevents is LoginEventPassWordChanged);
    } ).debounceTime(Duration(milliseconds: 300));
    final nonDebounceStream = loginevents.where((loginevents){
      return (loginevents is! LoginEventEmailChanged || loginevents is! LoginEventPassWordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async*{
    final loginState = state;
    if(loginEvent is LoginEventEmailChanged){
      yield loginState.cloneAndUpdate(isValidEmail: Validators.isValidEmail(loginEvent.email));
    }else if(loginEvent is LoginEventPassWordChanged){
      yield loginState.cloneAndUpdate(isValidPassword: Validators.isValidPassWord(loginEvent.password));
    }else if(loginEvent is LoginEventWithEmailAndPasswordPressed){
      try{
        await _userRepository.signInWithEmailAndPassword(loginEvent.email, loginEvent.password);
        yield LoginState.success();
      }catch(_){
        yield LoginState.failure();
      }
    }else if(loginEvent is LoginEventWithGooglePressed){
      try{
        await _userRepository.signInWithGoogle();
        yield LoginState.success();
      }catch(_){
        yield LoginState.failure();
      }
    }

  }

}