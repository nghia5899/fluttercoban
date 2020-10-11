import 'package:firebase_login_bloc/blocs/authentication_bloc.dart';
import 'package:firebase_login_bloc/blocs/register_bloc.dart';
import 'package:firebase_login_bloc/events/authentication_event.dart';
import 'package:firebase_login_bloc/events/register_event.dart';
import 'package:firebase_login_bloc/repositories/user_repository.dart';
import 'package:firebase_login_bloc/states/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_login_bloc/blocs/register_bloc.dart';


import 'buttons/register_button.dart';

class RegisterPage extends StatefulWidget {

  final UserRepository _userRepository;
  RegisterPage({Key key,@required UserRepository userRepository}):
        assert(userRepository!=null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPage();
}
class  _RegisterPage extends State<RegisterPage>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  RegisterBloc _registerBloc;
  UserRepository get _userRepository => widget._userRepository;
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isRegisterButtonEnable(RegisterState registerState) =>
      registerState.isValidEmailAndPassword && isPopulated && !registerState.isSubmitting;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(() {
      _registerBloc.add(RegisterEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _registerBloc.add(RegisterEventPassWordChanged(password: _passwordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RegisterBloc,RegisterState>(
        builder: (context,registerState){
          if(registerState.isFailure){
            print('Login Failure');
          }else if(registerState.isSubmitting){
            print('Registrationin progress...');
          }else if(registerState.isSuccess){
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
                        labelText: 'Email'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_){
                      return !registerState.isValidEmail ? 'Invalid email':null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_){
                      return !registerState.isValidPassword ? 'Invalid password ':null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: RegisterButton(
                      onPressed: (){
                        if(isRegisterButtonEnable(registerState)){
                          _registerBloc.add(
                            RegisterEventPressed(email: _emailController.text, password: _passwordController.text)
                          );
                        }
                      },
                    ),)
                ],
              ),
            ),);
        },
      ),
    );
  }
}
