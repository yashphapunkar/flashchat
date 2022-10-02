import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'loginscreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Color(0xFFD4D4D4),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/lightbulb.gif'),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                style: TextStyle(color: Color(0xFF37474F)),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color:Color(0xFF37474F)),
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color:  Color(0xFF455A64),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 10.0,
                  child: MaterialButton(
                    onPressed: () async {
                      setState((){
                        showSpinner = true;
                      });
                      try {
                       final user = await _auth.signInWithEmailAndPassword(
                           email: email, password: password);
                       if (user != null) {
                         Navigator.pushNamed(context, ChatScreen.id);
                         setState((){
                           showSpinner = false;
                         });
                       }
                     }
                     catch(e){
                       print(e);
                     }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
