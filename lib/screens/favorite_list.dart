
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:voca_voca/book/book.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voca_voca/screens/home_screen.dart';

import '../book/topics.dart';
import '../utils/theme_model.dart';
import 'background.dart';


class Favorite extends StatefulWidget {


  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  List favoriteList = [];
  var item = 0;
  GetStorage box = GetStorage();

  removeFromList(value)async{
    favoriteList.removeAt(value);
  }


  @override
  void initState() {
    favoriteList = box.read("list");
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    box.write("list", favoriteList);
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/${themes[box.read("theme")?? 0].photo}.jpg"),
              fit: BoxFit.cover,),
            color: Colors.deepPurple.shade100,
            // image: DecorationImage(image: AssetImage("assets/back2.jpg"),
            //   fit: BoxFit.cover,
            //   colorFilter: ColorFilter.mode(Colors.deepPurpleAccent, BlendMode.overlay))
          ),
          child:
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: IconThemeData(color: themes[box.read("theme")??0].appBarIconColor),
              centerTitle: true,
              title: Text("Sonra okunacaklar", style: GoogleFonts.aldrich(fontSize: 20 , fontWeight: FontWeight.bold, color: themes[box.read("theme")??0].appBarTextColor )),
              scrolledUnderElevation: 0,
              shadowColor: Colors.transparent,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [

              ],
            ),


            body: Animate(
              effects: [FadeEffect(), ScaleEffect()],
              child: SizedBox(
                  child:
                  favoriteList.length == 0 ? Center(child: Text("İçerik bulunamadı", style: GoogleFonts.poppins(fontSize: 30, color: themes[box.read("theme")??0].appBarTextColor),),)
                      : Swiper(
                    loop: true,
                    onIndexChanged: (index){
                      setState(() {
                        item =  index;
                      });
                    },
                    itemCount: favoriteList.length,
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                                    child: GestureDetector(
                                        onLongPress: (){
                                          Clipboard.setData(ClipboardData(text: box.read("list")[index]))
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
                                        },
                                        child: Text(favoriteList[index],textAlign: TextAlign.center, style:themes[box.read("theme")??0].style,)),
                                  ),
    SizedBox(height: 20,),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 80.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    IconButton.filledTonal(onPressed: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>BackgroundScreen(box.read("list")[index])));
    }, icon: Icon(Icons.ios_share, color: Colors.deepPurple)),
    IconButton.filledTonal(onPressed: (){
    Clipboard.setData(ClipboardData(text: box.read("list")[index]))
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

    IconButton.filledTonal(
    icon:  Icon(
    Icons.favorite, color: Colors.deepPurple,),
    onPressed: (){
      setState(() {
        setState(() {
          removeFromList(item);
        });
        // box.read("list").contains(wordInSwiper) ? removeFromList(wordInSwiper) : addToList(wordInSwiper);
      });
    })],
                              ),
                            ),
                          ]),
                      ))],
                      );
                    },
                  )),
            ),
          )




      ),
    );
  }
}