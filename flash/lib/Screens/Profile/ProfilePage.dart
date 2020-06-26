import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flippoapp/components/SizeConfig.dart';
import 'package:flippoapp/components/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
final _firestore = Firestore.instance;
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: SizeConfig.safeBlockVertical*8,),
              Container(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: SizeConfig.safeBlockHorizontal * 9.5,
                  foregroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical*2,),
              Container(
                child: Text(
                  'abc',
                  style: GoogleFonts.montserrat(
                      fontSize: SizeConfig.safeBlockHorizontal * 9.5,
                      fontWeight: FontWeight.bold,
                      color: Colorsys.black),
                ),
              ),
              ProfileStream(email:Colorsys.email)
            ],
          ),
        ),
      ),
    );
  }
}
class ProfileStream extends StatelessWidget {
  String email;
  ProfileStream({this.email});

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
        .collection("Users")
        .document(email)
        .collection("posts").orderBy("created", descending: true).snapshots(),
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

class Post extends StatelessWidget {
  DocumentSnapshot post;
  List<String> imgUrl = List<String>();
  Post({this.post});
  void init(){
    imgUrl.add(post.data["image1"]);
    imgUrl.add(post.data["image2"]);

  }
  @override
  Widget build(BuildContext context) {
    init();
    return Padding(
      padding: EdgeInsets.only(top:10.0),
      child: Container(
        height: SizeConfig.safeBlockVertical * 45,
        child: ListView.builder(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          scrollDirection: Axis.horizontal,
          itemCount: 2,
        itemBuilder: (context, index) {
          return Center(
            child: AspectRatio(
              aspectRatio: 1.1 / 1,
              child: Container(
                margin: EdgeInsets.all(
                  SizeConfig.safeBlockVertical * 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.fill,
                      width: double.infinity,
                      fadeInCurve: Curves.easeIn,
                      placeholder: 'assets/images/img.png',
                      image: imgUrl[index]
                  ),
                ),
              ),
            ),
          );
        }
        ),
      ),
    );
  }
}
