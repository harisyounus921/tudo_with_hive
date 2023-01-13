import 'dart:io';

import 'package:flutter/material.dart';

class detailScreen extends StatefulWidget {
  String title;
  String description;
  String image;
  detailScreen({required this.title,required this.description,required this.image,});
  @override
  _detailScreenState createState() => _detailScreenState();
}

class _detailScreenState extends State<detailScreen> {
 @override
 late String picture;
  void initState() {
    // TODO: implement initState
    super.initState();
    picture=widget.image.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toString()),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body:SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          children: <Widget>[
            Center(
              child: Hero(
                tag: 1,
                child: Container(
                  padding: EdgeInsets.only(top:8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox.fromSize(
                     // size: Size.fromRadius(300),
                      child: picture.toString()==null.toString()||picture.toString()==""?
                      Image.asset("assets/splash.png"):
                        Image.file(File(widget.image.toString())),
                    ),
                  ),
                )
                /*Container(
                  height: 450,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: //AssetImage("assets/splash.png")
                      FileImage(File(widget.image.toString())),
                    ),),),*/
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              child: Text("Description : "+
                widget.description.toString(),
                style: TextStyle(
                  fontSize: 18,
                  height: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
