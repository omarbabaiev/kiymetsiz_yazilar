
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
    if(favoriteList.contains("")||favoriteList.isEmpty){
      favoriteList.removeAt(0);
    }
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
              color: Colors.deepPurple.shade100,
              image: DecorationImage(image: AssetImage("assets/${themes[box.read("theme")?? 0].photo}.jpg"),
                fit: BoxFit.cover,)
            //   colorFilter: ColorFilter.mode(Colors.deepPurpleAccent, BlendMode.overlay))
          ) ,
          child:
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: IconThemeData(color: themes[box.read("theme")??0].appBarIconColor),
              centerTitle: true,
              title: Text("Sonra okunacaklar", style: GoogleFonts.aldrich(fontSize: 20 , fontWeight: FontWeight.bold , color: themes[box.read("theme")??0].appBarTextColor)),
              scrolledUnderElevation: 0,
              shadowColor: Colors.transparent,
              elevation: 0,
              backgroundColor: Colors.transparent,
              // actions: [
              //   IconButton(onPressed: (){
              //     // await _showModalSheet();
              //     setState(() {
              //       removeFromList(item);
              //     });
              //
              //     // box.read("list").contains(box.read("1") ?? false)
              //     //     ? SnackBar(
              //     //   duration: Duration(seconds: 1),
              //     //   showCloseIcon: true,
              //     //   content: Text("Listeden çıkartıldı", style: GoogleFonts.aldrich(color: Colors.deepPurple),),
              //     //   behavior: SnackBarBehavior.floating,
              //     //   backgroundColor: Colors.deepPurple.shade100,
              //     //   shape: StadiumBorder(),
              //     //
              //     // ) :  ScaffoldMessenger.of(context).showSnackBar(
              //     //     SnackBar(
              //     //       duration: Duration(seconds: 1),
              //     //       showCloseIcon: true,
              //     //       content: Text("Listeye eklendi", style: GoogleFonts.aldrich(color: Colors.deepPurple),),
              //     //       behavior: SnackBarBehavior.floating,
              //     //       backgroundColor: Colors.deepPurple.shade100,
              //     //       shape: StadiumBorder(),
              //     //
              //     //     ));
              //
              //   }, icon:   box.read("list").isEmpty ? SizedBox() :  Icon(Icons.favorite , color: Colors.deepPurple,)),
              //
              //
              //   IconButton(onPressed: (){
              //   }, icon: Icon(Icons.share, color: Colors.deepPurple,))
              // ],
            ),


            body: Animate(
              effects: [FadeEffect(), ScaleEffect()],
              child: SizedBox(
                  child:
                  favoriteList.length == 0 ? Center(child: Text("İçerik bulunamadı", style:  themes[box.read("theme")??0].style),)
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
                                          Clipboard.setData(ClipboardData(text: favoriteList[index]))
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
                                        child: Text(favoriteList[index],textAlign: TextAlign.center, style:   themes[box.read("theme")??0].style)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton.filledTonal(onPressed: (){
                                          Navigator.push(context, CupertinoPageRoute(builder: (context)=>BackgroundScreen(box.read("list")[index])));
                                        }, icon: Icon(Icons.ios_share, color: Colors.deepPurple)),
                                        IconButton.filledTonal(onPressed: (){
                                          Clipboard.setData(ClipboardData(text: favoriteList[index]))
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
                                             removeFromList(index) ;
                                          });


                                        }, icon:  Icon(Icons.favorite, color: Colors.deepPurple,),),

                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ),
          )




      ),
    );
  }
}