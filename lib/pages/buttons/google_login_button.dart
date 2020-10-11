import 'package:firebase_login_bloc/blocs/login_bloc.dart';
import 'package:firebase_login_bloc/events/login_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleLoginButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ButtonTheme(
      height: 45,
      child: RaisedButton.icon(
          onPressed: (){
            BlocProvider.of<LoginBloc>(context).add(LoginEventWithGooglePressed());
          },
          color: Colors.redAccent,
          icon: Icon(FontAwesomeIcons.google,color:  Colors.white,size: 17,),
          label: Text('Signin with Google',style: TextStyle(color: Colors.white,fontSize: 16),)),
    );
  }
  
}