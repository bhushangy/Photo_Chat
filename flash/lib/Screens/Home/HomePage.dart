import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippoapp/Screens/Home/Post.dart';
import 'package:flippoapp/components/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/SizeConfig.dart';

final _firestore = Firestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Container(
            color: Colors.white10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 3,
                      top: SizeConfig.safeBlockVertical * 4),
                  child: Text(
                    'Discover.',
                    style: GoogleFonts.montserrat(
                        fontSize: SizeConfig.safeBlockHorizontal * 9.5,
                        fontWeight: FontWeight.bold,
                        color: Colorsys.black),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 6,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 2.5,
                ),
                PostStream()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostStream extends StatelessWidget {

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
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('AllUsers')
          .orderBy("created", descending: true)
          .snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          _showDialog("No internet!",
              "Please check your internet connectivity.", context);
        }

        final posts = snapshot.data.documents;
        if(posts.length == 0)
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height*0.5,
            child: Text(
            'No Posts Found!!',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 5),
          ),);
        List<Post> postRows = [];
        for (var post in posts) {
          final postRow = Post(
            post: post,
          );
          postRows.add(postRow);
        }
        return SingleChildScrollView(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          scrollDirection: Axis.vertical,
          child: Column(
            children: postRows,
          ),
        );
      },
    );
  }
}
