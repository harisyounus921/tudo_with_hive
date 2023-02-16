import 'dart:io';
import 'dart:math'as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tudo_with_hive/models/notes_model.dart';
import 'package:tudo_with_hive/screens/detailedScreen/detailScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen2 extends StatefulWidget {
  Box<NotesModel> box;
  String title;
  HomeScreen2({Key? key,required this.box,required this.title}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>{

  NumberFormat formatter = NumberFormat("00");
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime globalDate=DateTime.now();
  DateTime globalPreviousDate=DateTime.now();
  TimeOfDay globalTime=TimeOfDay.now();
  late String imagePath;
  bool status=false;
  bool currentDate=false;

  List<Color> colors =const [Color(0xFF4AAEF4) , Color(0xFF52D887),
    Color(0xFFD97941),
    Colors.deepPurpleAccent] ;

  math.Random random = math.Random();

  void pickimage()async{
    final ImagePicker _picker=ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath=image!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(widget.title.toString(),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
      ),

      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: widget.box.listenable(),
        builder: (context,box ,_){
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return Dismissible(
                key: UniqueKey(),
               // key: Key(data[index].toString()),
                onDismissed: (direction) {
                    _delete(data[index]);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('1 item dismissed')));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 10.0),

                  child: ListTile(
                    tileColor: data[index].status?Color(0xFF52D887): Color(0xFF4AAEF4),
                    //  tileColor:  colors[random.nextInt(4)],
                   // tileColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1,color: Colors.black54),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onLongPress: (){
                      _editDialog(data[index], data[index].title.toString(), data[index].description.toString(),
                          data[index].image.toString(),data[index].date.toString(),data[index].time.toString(),);
                    },

                    leading: Transform.scale(
                        scale: 1.7,
                      child: Checkbox(
                          value: data[index].status,
                          activeColor: Colors.green,
                          onChanged:(bool ?newValue){
                            setState(() {
                             status = newValue!;
                            });
                            box.putAt(index, NotesModel(title: data[index].title,
                              description: data[index].description,
                              image: data[index].image,
                              time: data[index].time,
                              date: data[index].date,
                              status: status,
                            ));
                            status=false;
                          }),
                    ),
                    trailing: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            detailScreen(title: data[index].title.toString(),
                              description: data[index].description.toString(),
                              image: data[index].image.toString(),
                            date: data[index].date.toString(),
                              time: data[index].time.toString(),
                            )));
                      },
                      child: data[index].image.toString()==null.toString()||data[index].image.toString()==""?
                      const CircleAvatar(radius: 30,backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/splash.png"),
                      ): CircleAvatar(radius: 30,backgroundColor: Colors.white,
                        backgroundImage: FileImage(File(data[index].image.toString())),
                      ),
                    ),
                      title:InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              detailScreen(title: data[index].title.toString(),
                                description: data[index].description.toString(),
                                image: data[index].image.toString(),
                                date: data[index].date.toString(),
                                time: data[index].time.toString(),
                              )));
                        },
                        child: Text("   ${data[index].title}" ,
                          style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.w500 , color: Colors.white),),
                      ),
                    subtitle:    InkWell(
                      onTap: (){


                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            detailScreen(title: data[index].title.toString(),
                              description: data[index].description.toString(),
                              image: data[index].image.toString(),
                              date: data[index].date.toString(),
                              time: data[index].time.toString(),
                            )));
                      },
                      child: Text(data[index].time+" "+data[index].date,
                        style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.white),),
                    ),
                  ),
                ),
              );
              },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black87,
        onPressed: ()async{
          _showDialog(widget.box);
        },
        child: const Icon(Icons.add),
      ),
    );

  }

  void _delete(NotesModel notesModel)async{
    await notesModel.delete() ;
  }

  Future<void> _editDialog(NotesModel notesModel, String title,
      String description,String image,String date1,String time1 )async{

    titleController.text = title ;
    descriptionController.text = description ;
    imagePath=image;
    DateTime editdate=DateTime.now();
    TimeOfDay edittime= TimeOfDay.now();

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: const Text('Edit Item information'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      pickimage();
                    },
                    child: Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(child: Text("Change Photo",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600))),
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Due Time:"),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black),),

                        child: Text(time1,style:
                        const TextStyle(fontSize: 18,color: Colors.white,
                            backgroundColor: Colors.black),),

                        onPressed: ()async {
                          TimeOfDay? newtime =await showTimePicker(
                              context: context, initialTime: await TimeOfDay.now());
                          if(newtime==null)return;
                          setState(() {
                            edittime=newtime;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Due Date:"),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black),),

                        child: Text(date1,
                          style: const TextStyle(fontSize: 18,color: Colors.white,
                              backgroundColor: Colors.black),),

                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: editdate,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2050),
                          );
                          if (newDate == null) return;
                          setState(() {
                            editdate = newDate;
                          });
                        },
                      ),

                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                titleController.clear();
                descriptionController.clear();
                imagePath = null.toString();
                Navigator.pop(context);}, child: const Text('Cancel')),

              TextButton(onPressed: ()async{

                String d1=editdate.day.toString()+"-"+editdate.month.toString()+"-"+editdate.year.toString();
                late int newtime;
                String am="am";
                if(edittime.hour==12){
                  am="pm";
                  newtime=edittime.hour;
                }else if(edittime.hour>11){
                  newtime=edittime.hour-12;
                  am="pm";
                }else{
                  newtime=edittime.hour;
                }
                String t1="${newtime.toString()}:${formatter.format(edittime.minute)} ${am}";

                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();
                notesModel.image=imagePath;
                notesModel.time=t1.toString();
                notesModel.date=d1.toString();

                notesModel.save();
                descriptionController.clear() ;
                titleController.clear() ;
                imagePath=null.toString();

                Navigator.pop(context);
              }, child: const Text('Edit')),
            ],
          );
        }
    ) ;
  }

  Future <void>_showDialog( Box<NotesModel> boxes)async{
    return showDialog(
      context: context,
      builder:(context) {
          return StatefulBuilder(
             builder: (context,setState){
               return AlertDialog(
                 title: const Text('Uplode the Item information',style: TextStyle(fontSize: 18),),
                 content: SingleChildScrollView(
                     child: Column(
                       children: [
                         //const SizedBox(height: 20.0,),
                         TextFormField(
                           controller: titleController,
                           // autofocus: true,
                           decoration: const InputDecoration(
                               hintText: 'Enter Title',
                               border: OutlineInputBorder()
                           ),
                         ),
                         const SizedBox(height: 15.0,),
                         TextFormField(
                           controller: descriptionController,
                           decoration: const InputDecoration(
                               hintText: 'Enter description',
                               border: OutlineInputBorder()
                           ),
                         ),

                         const SizedBox(height: 15,),
                         InkWell(
                           onTap: (){
                             pickimage();
                           },
                           child: Container(
                             height: 55,
                             width: MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(
                               color: Colors.black87,
                               borderRadius: BorderRadius.circular(30),
                             ),
                             child: const Center(child: Text("Reference Photo",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600))),
                           ),
                         ),

                         const SizedBox(height: 15.0,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             const Text("Due Time:"),
                             ElevatedButton(
                               style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.all(Colors.black),),

                               child: Text(globalTime.format(context).toString(),style:
                               const TextStyle(fontSize: 18,color: Colors.white,
                                   backgroundColor: Colors.black),),

                               onPressed: ()async {
                                 TimeOfDay? newtime =await showTimePicker(
                                     context: context, initialTime: await TimeOfDay.now());
                                 if(newtime==null)return;
                                 setState(() {
                                   globalTime=newtime;
                                 });
                               },
                             ),
                           ],
                         ),
                         const SizedBox(height: 15.0,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             const Text("Due Date:"),
                             ElevatedButton(
                               style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.all(Colors.black),),

                               child: Text('${globalDate.day}/${globalDate.month}/${globalDate.year}',
                                 style: const TextStyle(fontSize: 18,color: Colors.white,
                                     backgroundColor: Colors.black),),

                               onPressed: () async {
                                 DateTime? newDate = await showDatePicker(
                                   context: context,
                                   initialDate: globalDate,
                                   firstDate: DateTime(2023),
                                   lastDate: DateTime(2050),
                                 );
                                 if (newDate == null) return;
                                 setState(() {
                                   globalDate = newDate;
                                   globalPreviousDate=newDate;
                                 });
                               },
                             ),
                           ],
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Checkbox(
                                 value: currentDate,
                                 activeColor: Colors.black,
                                 onChanged:(bool ?newValue){
                                   setState(() {
                                     currentDate = newValue!;
                                     if(currentDate==true)
                                     {
                                       globalDate = DateTime.now();
                                     }
                                     else if(currentDate==false)
                                     {
                                       globalDate=globalPreviousDate;
                                     }
                                   });
                                 }),
                             const Text(
                               "CURRENT DATE",
                               style: TextStyle(color: Colors.deepPurple),
                             ),
                           ],
                         ),
                         const Divider(
                           color: Colors.black,
                         ),
                       ],
                     )
                 ),
                 actions: [
                   TextButton(onPressed: () {
                     titleController.clear();
                     descriptionController.clear();
                     imagePath = null.toString();
                     currentDate=false;

                     Navigator.pop(context);
                   }, child: const Text('Cancel')),

                   TextButton(onPressed: () async {
                     if (titleController.text
                         .trim()
                         .isEmpty) {
                       Fluttertoast.showToast(msg: "Please write the Title.",
                           textColor: Colors.white,
                           backgroundColor: Colors.green);
                     } else if (imagePath.isEmpty || imagePath == null.toString() ||
                         imagePath == "") {
                       Fluttertoast.showToast(msg: "Please Select the Image",
                           textColor: Colors.white,
                           backgroundColor: Colors.green);
                     } else {
                       try{
                         late int newhourtime;
                         String am="am";
                         if(globalTime.hour==12){
                           am="pm";
                           newhourtime=globalTime.hour;
                         }else if(globalTime.hour>11){
                           newhourtime=globalTime.hour-12;
                           am="pm";
                         }else{
                           newhourtime=globalTime.hour;
                         }
                         String t1="$newhourtime:${formatter.format(globalTime.minute)} ${am}";
                         String d1="${globalDate.day}-${globalDate.month}-${globalDate.year}";

                         final data = NotesModel(title: titleController.text,
                           description: descriptionController.text,
                           image: imagePath,
                           time: t1,
                           date: d1,
                           status: status,
                         );

                         titleController.clear();
                         descriptionController.clear();
                         imagePath = null.toString();
                         currentDate=false;

                         final box = boxes;
                         box.add(data);

                         Navigator.pop(context);
                       }catch(e){
                         Fluttertoast.showToast(msg: e.toString(),
                             textColor: Colors.white,
                             backgroundColor: Colors.green);
                       }
                     }
                   }, child: const Text('Done')),
                 ],
               );
            }
          );
        },
    );
  }
}
extension on String {
  operator >(String other){
    return double.parse(this) > double.parse(other);
  }
}


