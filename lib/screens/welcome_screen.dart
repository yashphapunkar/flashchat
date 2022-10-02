import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class WelcomeScreen extends StatefulWidget {
  static String id = 'welcomescreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController controller, controller2;
  late Animation animation;
  late Animation animation2;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    controller2 = AnimationController(
      duration: Duration(seconds:  2),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation2 = ColorTween(begin:Color(0xFFCFD8DC), end: Color(0xFFD4D4D4)).animate(controller2);
    controller2.forward();
    controller.forward();
    controller2.addListener(() {
      setState((){
       animation2.value;
      });
    });
    controller.addListener(() {
      setState((){
       animation.value*100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation2.value,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('images/lightbulb.gif'),
                height: animation.value*100*2,
              ),
            ),
            SizedBox(
              height:30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

               DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                      offset: Offset(2.0, 2.0), //position of shadow
                      blurRadius: 50.0, //blur intensity of shadow
                      color: Colors.black54.withOpacity(0.4), //color of shadow with opacity
                ), //add more shadow with different position offset here
              ]
            ),
                 child: AnimatedTextKit(
                   animatedTexts: [
                     TypewriterAnimatedText(
                         'Flash Chat',
                       textAlign: TextAlign.center,
                       textStyle: TextStyle(
                         fontFamily: 'EduNSWACTFoundation',
                       ),
                       speed: const Duration(milliseconds: 70),
                     )
                   ],
                   isRepeatingAnimation: true,
                   onTap: () {
                     print("Tap Event");
                   },
                 ),
           ),
         ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Divider(
                height: 20,
                color: Colors.black,
              ),
            ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 13),
          child: Material(
            elevation: 10.0,
            color:  Color(0xFF455A64),//Color(0xFF455A64),
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);

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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 13),
              child: Material(
                color: Color(0xFF37474F),
                borderRadius: BorderRadius.circular(30),
                elevation: 10.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
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
    );
  }
}








