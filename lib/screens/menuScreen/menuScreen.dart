import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';
import 'package:tudo_with_hive/models/notes_model.dart';
import 'package:tudo_with_hive/screens/homeScreen/homeScreen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class menuScreen extends StatefulWidget {
  const menuScreen({Key? key}) : super(key: key);

  @override
  _menuScreenState createState() => _menuScreenState();
}

class _menuScreenState extends State<menuScreen> {
  List<Color> colors = [const Color(0xFF4AAEF4) , const Color(0xFF52D887), const Color(0xFFD97941),
    const Color(0xFFD64F4F),Colors.deepPurpleAccent] ;

  List<String> name=["Home","Work",'Health','Private','Add more'];

  List<Icon> icons=[const Icon( Icons.home_outlined,color: Colors.white,size: 50,),
    const Icon( Icons.store_mall_directory,color: Colors.white,size: 50,),
    const Icon( Icons.health_and_safety_outlined,color: Colors.white,size: 50,),
    const Icon( Icons.offline_bolt,color: Colors.white,size: 50,),
    const Icon( Icons.add,color: Colors.white,size: 50,),];

  List list = [
    HomeScreen2(box: Hive.box<NotesModel>('home'),title: "Home Related Task",),
    HomeScreen2(box: Hive.box<NotesModel>('work'),title: "Work Related Task",),
    HomeScreen2(box: Hive.box<NotesModel>('health'),title: "Health Related Task",),
    HomeScreen2(box: Hive.box<NotesModel>('private'),title: "Private Related Task",),
    const Scaffold(body: Center(child: Text("Under Development"),),),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[300],
       // centerTitle: true,
       title: const Text('Goals',style: TextStyle(fontSize: 40,fontWeight: FontWeight.w900),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: name.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => list[index]));
                },
                child: Container(
                  decoration:BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(name[index],style: const TextStyle(fontSize: 30,color: Colors.white),),
                      icons[index],
                      const Text("Last Check Status",style: TextStyle(fontSize: 12,color: Colors.white),),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("4/5",style: TextStyle(
                                fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
                            CircularPercentIndicator(
                              radius: 16.0,
                              lineWidth: 5.0,
                              percent: 0.75,
                              //center: Text("100%"),
                              progressColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              );
            }),
      ),
    );
  }
}
