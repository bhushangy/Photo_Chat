import 'package:flippoapp/components/BottomAppBar/BottomAppBar.dart';
import 'package:flippoapp/components/Colors.dart';
import 'package:flippoapp/components/reusable_buttons.dart';
import 'package:flippoapp/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/SizeConfig.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String passHint = 'Enter your password';
  String emailHint = 'Enter your email';
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();

  void _showDialog(
      String a,
      String b,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(
              SizeConfig.safeBlockHorizontal * 6.2,
              SizeConfig.safeBlockHorizontal * 2,
              SizeConfig.safeBlockHorizontal * 4,
              SizeConfig.safeBlockHorizontal * 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: new Text(
            a,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 5),
          ),
          content: new Text(
            b,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.normal,
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                " OK",
                style:
                TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5),
              ),
              onPressed: () {
                emailControl.clear();
                passControl.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height:  MediaQuery.of(context).size.width*0.4,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.06,
              ),
              TextField(
                controller: emailControl,
                  onTap: () => setState(() {
                        passHint = 'Enter your password';
                        emailHint = '';
                      }),
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: emailHint)),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.03,
              ),
              TextField(
                controller: passControl,
                  onTap: () => setState(() {
                        passHint = '';
                        emailHint = 'Enter your email';
                      }),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: new TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: passHint)),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.03,
              ),
              reusableButtons(
                colour: Colors.lightBlueAccent,
                txt: 'Log In',
                onPressed: () async {
                  if (email == null || password == null || emailControl.text.isEmpty || passControl.text.isEmpty) {
                    _showDialog("Error", "Email or Password cannot be empty!!");
                    return;
                  }

                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      emailControl.clear();
                      passControl.clear();
                     // Navigator.pushNamed(context, ChatScreen.id);
                    }
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.setString('email', email);
                    Colorsys.email = email;
                    setState(() {
                      showSpinner = false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomAppB()));
                  } catch (e) {
                    print(e);
                    String err = e.toString();
                    List<String> errList = err.split(',');
                    print(errList);
                    _showDialog("Error", errList[1]+"Try Again!!");
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
