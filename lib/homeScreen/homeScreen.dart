import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../box/box.dart';
import '../models/notes_model.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>{

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late String imagePath;

  List<Color> colors = [Colors.indigoAccent , Colors.black38, Colors.deepPurpleAccent, Colors.blue , Colors.red] ;

  Random random = Random(3);

  void pickimage()async{
    final ImagePicker _picker=ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath=image!.path;
    });
  }

  void pickcamera()async{
    final ImagePicker _picker=ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imagePath=image!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text('Hive Tudo Application'),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box ,_){
          var data = box.values.toList().cast<NotesModel>();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
                itemCount: box.length,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return Padding(
                    //padding: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: ListTile(
                      tileColor: colors[random.nextInt(4)],

                      leading: CircleAvatar(radius: 30,backgroundColor: Colors.white,
                        backgroundImage: FileImage(File(data[index].image.toString())),
                      ),

                      title: Text("     "+data[index].title.toString() ,
                        style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.w500 , color: Colors.white),),

                      subtitle: Text("     "+data[index].description.toString(),
                        style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.w300, color: Colors.white),),

                      trailing:PopupMenuButton(
                        icon: Icon(Icons.more_vert ,color: Colors.white,),
                        iconSize: 35,
                        onSelected: (value) {
                          if (value==1){
                            _editDialog(data[index], data[index].title.toString(),
                                data[index].description.toString(), data[index].image.toString());
                          }else if(value==2){
                            _delete(data[index]);
                          }
                        },
                        itemBuilder: (context) =>
                        [
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [Icon(Icons.edit,color: Colors.white,), SizedBox(width: 10,),
                                Text("Edit",style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: [Icon(Icons.delete,color: Colors.white,), SizedBox(width: 10,),
                                Text("delete",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                        ],
                        offset: Offset(0, 20),
                        color: Colors.green,
                        elevation: 8,
                      ),
                    ),
                  );
                }
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: ()async{
          _showDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _delete(NotesModel notesModel)async{
    await notesModel.delete() ;
  }

  Future<void> _editDialog(NotesModel notesModel, String title, String description,String image)async{

    titleController.text = title ;
    descriptionController.text = description ;
    imagePath=image;

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
                  TextButton(onPressed: (){
                    pickimage();
                  }, child: const Text('Change Gallery Photo')),
                  const SizedBox(height: 20,),
                  TextButton(onPressed: (){
                    pickcamera();
                  }, child: const Text('Change Camera Photo')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: ()async{

                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();
                notesModel.image=imagePath;

                notesModel.save();
                descriptionController.clear() ;
                titleController.clear() ;

                Navigator.pop(context);
              }, child: const Text('Edit')),
            ],
          );
        }
    ) ;
  }

  Future <void>_showDialog()async{
    return showModalBottomSheet(
      context: context,
      builder: (context)=>Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft:Radius.circular(20.0),
              topRight:Radius.circular(20.0),
            )
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            const Text("Uplode the Item information",style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 30.0,
              color:Colors.green,
            )),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: titleController,
              // autofocus: true,
              decoration:  const InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: (){
                      pickimage();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(13)),
                    ),child: const Icon(Icons.image)),
                GestureDetector(
                  onTap: (){
                    final data = NotesModel(title: titleController.text,
                        description: descriptionController.text,
                        image: imagePath) ;

                    final box = Boxes.getData();
                    box.add(data);

                    titleController.clear();
                    descriptionController.clear();

                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 55,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(child: Text("Done",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600))),
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      pickcamera();
                      },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(13)),
                    ),child: const Icon(Icons.camera)),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
          ],
        ),),
    );
  }


}