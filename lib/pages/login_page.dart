import 'package:firebase_login_bloc/blocs/authentication_bloc.dart';
import 'package:firebase_login_bloc/blocs/login_bloc.dart';
import 'package:firebase_login_bloc/events/authentication_event.dart';
import 'package:firebase_login_bloc/events/login_event.dart';
import 'package:firebase_login_bloc/pages/buttons/google_login_button.dart';
import 'package:firebase_login_bloc/pages/buttons/login_button.dart';
import 'package:firebase_login_bloc/pages/buttons/register_button.dart';
import 'package:firebase_login_bloc/pages/buttons/register_user_button.dart';
import 'package:firebase_login_bloc/repositories/user_repository.dart';
import 'package:firebase_login_bloc/states/authentication_state.dart';
import 'package:firebase_login_bloc/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class LoginPage extends StatefulWidget {

  final UserRepository _userRepository;
  LoginPage({Key key,@required UserRepository userRepository}):
      assert(userRepository!=null),
      _userRepository = userRepository,
      super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}
class  _LoginPageState extends State<LoginPage>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isLoginButtonEnable(LoginState loginState) =>
      loginState.isValidEmailAndPassword && isPopulated && !loginState.isSubmitting;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _loginBloc.add(LoginEventPassWordChanged(password: _passwordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc,LoginState>(
        builder: (context,loginState){
          if(loginState.isFailure){
            print('Login Failure');
          }else if(loginState.isSubmitting){

          }else if(loginState.isSuccess){
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationEventLoggedIn());
          }
          return Padding(
              padding:EdgeInsets.all(20),
              child: Form(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Enter your email'
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autovalidate: true,
                      validator: (_){
                        return loginState.isValidEmail ? null:'Invalid email format';
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password your email'
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      autocorrect: false,
                      autovalidate: true,
                      validator: (_){
                        return loginState.isValidPassword ? null:'Invalid password format';
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LoginButton(
                              onPressed: isLoginButtonEnable(loginState)?
                              _onLoginEmailAndPassword: null,
                            ),
                            Padding(padding: EdgeInsets.only(top: 10,),),
                            GoogleLoginButton(),
                            Padding(padding: EdgeInsets.only(top: 10,),),
                            RegisterUserButton(userRepository: _userRepository)
                          ],
                        )),


                  ],
                ),
              ),);
        },
      ),
    );
  }
  void _onLoginEmailAndPassword(){
    _loginBloc.add(LoginEventWithEmailAndPasswordPressed(
      email: _emailController.text,
      password: _passwordController.text
    ));
  }
}
