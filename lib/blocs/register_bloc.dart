import 'package:firebase_login_bloc/events/register_event.dart';
import 'package:firebase_login_bloc/repositories/user_repository.dart';
import 'package:firebase_login_bloc/states/register_state.dart';
import 'package:firebase_login_bloc/validators/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_login_bloc/states/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent,RegisterState>{
  UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository}):
        assert(userRepository!=null),
        _userRepository = userRepository, super(RegisterState.iniital());

  //khoang tre giua 2 lan an
  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(Stream<RegisterEvent> Registerevents, transitionFn) {
    final debounceStream = Registerevents.where((Registerevents) {
      return (Registerevents is RegisterEventEmailChanged || Registerevents is RegisterEventPassWordChanged);
    } ).debounceTime(Duration(milliseconds: 300));
    final nonDebounceStream = Registerevents.where((Registerevents){
      return (Registerevents is! RegisterEventEmailChanged || Registerevents is! RegisterEventPassWordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }



  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async*{
    final registerState = state;
    if(registerEvent is RegisterEventEmailChanged){
      yield registerState.cloneAndUpdate(isValidEmail: Validators.isValidEmail(registerEvent.email));
    }else if(registerEvent is RegisterEventPassWordChanged){
      yield registerState.cloneAndUpdate(isValidPassword: Validators.isValidPassWord(registerEvent.password));
    }else if(registerEvent is RegisterEventPressed){
      yield RegisterState.loading();
      try{
        await _userRepository.createUserWithEmailAndPassword(registerEvent.email, registerEvent.password);
        yield RegisterState.success();
      }catch(exception){
        print(exception.toString());
        yield RegisterState.failure();
      }
    }
    }

  }
