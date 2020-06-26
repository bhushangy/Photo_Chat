import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flippoapp/components/SizeConfig.dart';
import 'package:flippoapp/components/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';


final _firestore = Firestore.instance;
class Post extends StatefulWidget {
  DocumentSnapshot post;
  Post({this.post});
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  List<String> imgUrl = List<String>();
  bool isLike;
  String heartPath;
  void initState(){
    super.initState();
    imgUrl.add(widget.post.data["image1"]);
    imgUrl.add(widget.post.data["image2"]);
    isLike = widget.post.data['likes'];
    isLike?heartPath = 'assets/images/fillh.png':heartPath='assets/images/emptyh.png';
  }

  Future<void> updateRecord()async{
    if(heartPath=='assets/images/emptyh.png'){
      heartPath = 'assets/images/fillh.png';
      try {
        await _firestore
            .collection("AllUsers") //
            .document(widget.post.documentID).updateData({"likes": true});
      } catch (e) {
        print(e);
      }

    }else{
      heartPath='assets/images/emptyh.png';
      try {
        await _firestore
            .collection("AllUsers") //
            .document(widget.post.documentID).updateData({"likes": false});
      } catch (e) {
        print(e);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      //color: Color(0xFFE8EAF6),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Padding(
              padding:
              EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: SizeConfig.safeBlockHorizontal * 5.5,
                    foregroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/bescom.png'),
                  ),
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 3.2,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.post.data["email"],
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.post.data["email"],
                              style: TextStyle(
                                  fontSize:
                                  SizeConfig.safeBlockHorizontal * 3.2,
                                  color: Colorsys.grey),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.safeBlockHorizontal * 5),
                              child: Text(
                                '3d ago.',
                                style: TextStyle(
                                    fontSize: 13, color: Colorsys.grey),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: SizeConfig.safeBlockVertical * 45,
            padding: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical * 3.5,),
            child: ListView.builder(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 4.0),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: SizeConfig.safeBlockVertical*4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage.assetNetwork(
                                fit: BoxFit.fill,
                                width: double.infinity,
                                fadeInCurve: Curves.easeIn,
                                placeholder: 'assets/images/img.png',
                                image: imgUrl[index]
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () async{
                                if(heartPath=='assets/images/emptyh.png'){
                                  heartPath = 'assets/images/fillh.png';
                                  try {
                                    await _firestore
                                        .collection("AllUsers") //
                                        .document(widget.post.documentID).updateData({"likes": true});
                                  } catch (e) {
                                    print(e);
                                  }

                                }else{
                                  heartPath='assets/images/emptyh.png';
                                  try {
                                    await _firestore
                                        .collection("AllUsers") //
                                        .document(widget.post.documentID).updateData({"likes": false});
                                  } catch (e) {
                                    print(e);
                                  }
                                }

                              },
                              child: Container(
                                width:SizeConfig.safeBlockHorizontal*7,
                                height: SizeConfig.safeBlockVertical*4,
                                margin: EdgeInsets.all(SizeConfig.safeBlockHorizontal*2),
                                child: Image.asset(heartPath),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
