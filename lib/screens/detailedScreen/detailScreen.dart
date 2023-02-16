import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class detailScreen extends StatefulWidget {
  String title;
  String description;
  String image;
  String time;
  String date;
  detailScreen({required this.title,required this.description,
    required this.image,required this.time,required this.date});
  @override
  _detailScreenState createState() => _detailScreenState();
}

class _detailScreenState extends State<detailScreen> {
 @override
 late String picture;
  void initState() {
    super.initState();
    picture=widget.image.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(widget.title.toString(),style: const TextStyle(
            fontSize: 40,fontWeight: FontWeight.w400,color: Colors.deepPurple)),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.time,style: const TextStyle(fontSize: 18,color: Colors.deepPurple),),
                Text(widget.date,style: const TextStyle(fontSize: 18,color: Colors.deepPurple),),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Hero(
                tag: 1,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(200),
                      child: picture.toString()==null.toString()||picture.toString()==""?
                      Image.asset("assets/splash.png",fit: BoxFit.fill,):
                        Image.file(File(widget.image.toString()),fit: BoxFit.fitHeight,),
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
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: Colors.black87,
              child: Text("Description : ${widget.description}",
                style: const TextStyle(
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
