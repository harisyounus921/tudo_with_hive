import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {

  @HiveField(0)
  String title ;

  @HiveField(1)
  String description;

  @HiveField(2)
  String image ;

  @HiveField(3)
  bool status ;

  @HiveField(4)
  String date;


  @HiveField(5)
  String time;


  NotesModel({required this.title , required this.description , required this.image,
required this.status,required this.date, required this.time}) ;

}