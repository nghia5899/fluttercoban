import 'package:firebase_login_bloc/blocs/authentication_bloc.dart';
import 'package:firebase_login_bloc/blocs/login_bloc.dart';
import 'package:firebase_login_bloc/blocs/simple_bloc_observer.dart';
import 'package:firebase_login_bloc/events/authentication_event.dart';
import 'package:firebase_login_bloc/pages/login_page.dart';
import 'package:firebase_login_bloc/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/simple_bloc_observer.dart';
import 'pages/splash.dart';
import 'pages/home_page.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      home: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)..add(AuthenticationEventStarted()),
        child:  BlocBuilder<AuthenticationBloc,AuthenticationState>(
          builder: (context,authenticationState){
            if(authenticationState is AuthenticationStateInitial){
              return SplashPage();
            }else if(authenticationState is AuthenticationStateSuccess){
              return HomePage();
            }else if(authenticationState is AuthenticationStateFailure){
              return BlocProvider<LoginBloc>(
                  create: (context)=>LoginBloc(userRepository: _userRepository),
                  child: LoginPage(userRepository: _userRepository,),);
            }
          },
        ),
      )
    );
  }
}

