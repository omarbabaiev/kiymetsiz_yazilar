import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:voca_voca/book/book.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voca_voca/screens/background.dart';
import 'package:voca_voca/screens/favorite_list.dart';
import 'package:voca_voca/screens/themes.dart';
import 'package:voca_voca/screens/topics.dart';
import '../book/topics.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

import '../utils/theme_model.dart';

class HomeScreen extends StatefulWidget {
  final bookContent;

  HomeScreen(this.bookContent);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var bookContent = [];





  List favoriteList = [];
  String wordInSwiper = "";

  GetStorage box = GetStorage();

  addToList(value)async{
    favoriteList.add(value);
    box.write("list",favoriteList);
  }
  removeFromList(value)async{
    favoriteList.remove(value);
    box.write("list", favoriteList);
  }





  @override
  void initState() {
     bookContent =  widget.bookContent;
  // favoriteList = box.read("list")??["dsd", "Dsds"] ;
    box.write("list",[]);
    // _generateMembersMain();
    // TODO: implement initState
    super.initState();
  }


  GlobalKey previewContainer = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration:
        BoxDecoration(
            color: Colors.deepPurple.shade100,
            image: DecorationImage(image: AssetImage("assets/${themes[box.read("theme")?? 0].photo}.jpg"),
              fit: BoxFit.cover,)
            //   colorFilter: ColorFilter.mode(Colors.deepPurpleAccent, BlendMode.overlay))
        ) ,
          //   colorFilter: ColorFilter.mode(Colors.deepPurpleAccent, BlendMode.overla
          child:
              Scaffold(
                drawer: Drawer(),
                  backgroundColor: Colors.transparent,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: themes[box.read("theme")??0].appBarIconColor),
                  centerTitle: true,
                  title: Text("Kıymetsiz yazılar", style: GoogleFonts.aldrich(fontSize: 20 , fontWeight: FontWeight.bold, color: themes[box.read("theme")??0].appBarTextColor )),
                  scrolledUnderElevation: 0,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Favorite()));}, icon: Icon(Icons.favorite_border, )),
                    IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectTheme()));}, icon: Icon(Icons.interests, )),]),


                body: Animate(
                  effects: [FadeEffect(), ScaleEffect()],
                  child: SizedBox(
                      child: Swiper(
                        onIndexChanged: (index){
                          setState(() {
                            wordInSwiper = bookContent[index];
                            // box.write("1", list1[index]);
                          });
                        },
                        itemCount: bookContent.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return  Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.transparent,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                                    child: GestureDetector(
                                        onLongPress: (){
                                            Clipboard.setData(ClipboardData(text: bookContent[index]))
                                              .then((value) { //only if ->
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  duration: Duration(seconds: 1),
                                                  showCloseIcon: true,
                                                  content: Text("Metin kopyalandı", style: GoogleFonts.aldrich(color: Colors.deepPurple),),
                                                  behavior: SnackBarBehavior.floating,
                                                  backgroundColor: Colors.deepPurple.shade100,
                                                  shape: StadiumBorder(),

                                                ));
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(bookContent[index],textAlign: TextAlign.center, style: themes[box.read("theme")??0].style,),
                                            SizedBox(height: 20,),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 80.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconButton.filledTonal(onPressed: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BackgroundScreen(bookContent[index])));
                                                  }, icon: Icon(Icons.ios_share, color: Colors.deepPurple)),
                                                  IconButton.filledTonal(onPressed: (){
                                                    Clipboard.setData(ClipboardData(text: bookContent[index]))
                                                        .then((value) { //only if ->
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            duration: Duration(seconds: 1),
                                                            showCloseIcon: true,
                                                            content: Text("Metin kopyalandı", style: GoogleFonts.poppins(color: Colors.deepPurple),),
                                                            behavior: SnackBarBehavior.floating,
                                                            backgroundColor: Colors.deepPurple.shade100,
                                                            shape: StadiumBorder(),

                                                          ));
                                                    });
                                                  }, icon: Icon(Icons.copy, color: Colors.deepPurple)),
                                                  IconButton.filledTonal(onPressed: ()async{
                                                    setState(() {
                                                      box.read("list").contains!(wordInSwiper) ? removeFromList(wordInSwiper) : addToList(wordInSwiper);
                                                    });


                                                  }, icon:  Icon(
                                                    box.read("list").contains(wordInSwiper) ?  Icons.favorite :
                                                    Icons.favorite_border, color: Colors.deepPurple,),),

                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),

                            ],
                          );
                        },
                      )),),


                floatingActionButton: FloatingActionButton.extended(onPressed: () {
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Topics()));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Topics()));


                }, label: Text(box.read("topic")??"A, E, İ, Ü", style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.bold ), ),),
              )




      ),
    );
  }


}