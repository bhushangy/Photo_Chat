import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flippoapp/components/Colors.dart';
import 'package:flippoapp/components/reusable_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/SizeConfig.dart';


final databaseReference = Firestore.instance;

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String _uploadedFileURL= '';
  bool showSpinner = false;
  File image1;
  String email;

  Future getImage() async {
    FocusScope.of(context).unfocus(focusPrevious: true);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image1 = image;
      print('_image: $image1');
    });
  }
  Future getImage3() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      image1 = image;
      print('_image1: $image1');
    });
  }
  Future uploadFile(File image1) async {
    StorageReference storageReference;
    StorageUploadTask uploadTask;
    try {
        storageReference = FirebaseStorage.instance
            .ref()
            .child('images/$email/${Path.basename(image1.path)}}');
        uploadTask = storageReference.putFile(image1);
        await uploadTask.onComplete;
        print('File 1 Uploaded');
        await storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL = fileURL;
          });
        });

    } catch (e) {
      print(e);
    }

  }
  Future createRecord() async {
    try {
      await databaseReference
          .collection("AllUsers")
          .document() //widget.category.toUpperCase()
          .setData({
        'created': FieldValue.serverTimestamp(),
        'email':email,
        'image1': _uploadedFileURL,
        'image2': _uploadedFileURL,
        'likes': false,
      });

      await databaseReference
          .collection("Users")
          .document(email)
          .collection("posts").document().setData({
        'created': FieldValue.serverTimestamp(),
        'email':email,
        'image1': _uploadedFileURL,
        'image2': _uploadedFileURL,
        'likes': false,
      });
    } catch (e) {
      print(e);
    }
  }
  void _showDialog(
      String a,
      String b,
      BuildContext context,
      ) {
    // flutter defined function
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
    SizeConfig().init(context);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 3,
                      top: SizeConfig.safeBlockVertical * 4),
                  child: Text(
                    'Add a Post .',
                    style: GoogleFonts.montserrat(
                        fontSize: SizeConfig.safeBlockHorizontal * 9.5,
                        fontWeight: FontWeight.bold,
                        color: Colorsys.black),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 7,
                ),
                Padding(
                  padding:EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 3,
                    right: SizeConfig.safeBlockHorizontal * 3,
                     ),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          if(image1!=null){
                            setState(() {
                              image1=null;
                            });
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(width: 1.75, color: Colors.grey),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child:image1==null?
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: getImage3,
                                      child: Container(
                                          height: SizeConfig.safeBlockVertical*5,
                                          width: SizeConfig.safeBlockHorizontal*10,
                                          decoration: BoxDecoration(
                                              color: Color(0xffe0e0e0).withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(15.0)),
                                          child: Icon(Icons.camera,size:SizeConfig.safeBlockHorizontal*6,)),
                                    ),
                                    GestureDetector(
                                      onTap: getImage,
                                      child: Container(
                                          height: SizeConfig.safeBlockVertical*5,
                                          width: SizeConfig.safeBlockHorizontal*10,
                                          decoration: BoxDecoration(
                                              color: Color(0xffe0e0e0).withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(15.0)),
                                          child: Icon(Icons.photo_library,size:SizeConfig.safeBlockHorizontal*6,)),
                                    ),
                                  ],
                                ),
                              ):Image.file(
                                image1,
                                fit: BoxFit.fill,
                              ),
                              height:SizeConfig.safeBlockVertical * 60,
                              width:double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Padding(
                  padding:EdgeInsets.only(
                    left: SizeConfig.safeBlockHorizontal * 4,
                    right: SizeConfig.safeBlockHorizontal * 4,
                  ),
                  child: reusableButtons(
                      colour: Colors.lightBlueAccent,
                      txt: 'Post',
                      onPressed: () async{
                        if(image1==null){
                          return null;
                        }
                        setState(() {
                          showSpinner = true;
                        });
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        email = prefs.get('email');
                          await uploadFile(image1);
                          await createRecord();
                        setState(() {
                          showSpinner = false;
                        });
                        _showDialog('Done', 'Your Post has benn added', context);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}