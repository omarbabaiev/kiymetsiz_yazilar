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
import 'package:voca_voca/screens/topics.dart';
import '../book/topics.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class HomeScreen extends StatefulWidget {
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var bookContent = ky1+kyB;


  // void  _generateMembersMain() {
  //   return list1.shuffle();
  // }

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
  favoriteList = box.read("list")??["dsd", "Dsds"] ;
    // _generateMembersMain();
    // TODO: implement initState
    super.initState();
  }


  GlobalKey previewContainer = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            // image: DecorationImage(image: AssetImage("assets/back2.jpg"),
            //   fit: BoxFit.cover,
            //   colorFilter: ColorFilter.mode(Colors.deepPurpleAccent, BlendMode.overlay))
        ),
          child:
              Scaffold(
                drawer: Drawer(),
                  backgroundColor: Colors.transparent,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: Colors.deepPurple),
                  centerTitle: true,
                  title: Text("Kıymetsiz yazılar", style: GoogleFonts.aldrich(fontSize: 20 , fontWeight: FontWeight.bold )),
                  scrolledUnderElevation: 0,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.interests, color: Colors.deepPurple))
                  //   IconButton(onPressed:() {
                  //
                  //     //   await ShareFilesAndScreenshotWidgets().shareScreenshot(
                  //     //       previewContainer,
                  //     //       1000,
                  //     //       "Title",
                  //     //       "${wordInSwiper.substring(0, 10)}.png",
                  //     //       "image/png",
                  //     //       text: "This is the caption!");
                  //     //
                  //     // await Share.share(wordInSwiper);
                  //   }, icon: Icon(Icons.share, color: Colors.deepPurple,))
                  ]),

                body: Animate(
                  effects: [FadeEffect(), ScaleEffect()],
                  child: RepaintBoundary(
                    key: previewContainer,
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
                                              Text(bookContent[index],textAlign: TextAlign.center, style: GoogleFonts.aldrich(fontSize: 20 , ),),
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
                                                              content: Text("Metin kopyalandı", style: GoogleFonts.aldrich(color: Colors.deepPurple),),
                                                              behavior: SnackBarBehavior.floating,
                                                              backgroundColor: Colors.deepPurple.shade100,
                                                              shape: StadiumBorder(),

                                                            ));
                                                      });
                                                    }, icon: Icon(Icons.copy, color: Colors.deepPurple)),
                                                    IconButton.filledTonal(onPressed: ()async{
                                                    setState(() {
                                                    box.read("list").contains(wordInSwiper) ? removeFromList(wordInSwiper) : addToList(wordInSwiper);
                                                    });

                                                    // // await _showModalSheet();

                                                    //
                                                    // box.read("list").contains(box.read("1"))
                                                    //     ? SnackBar(
                                                    //   duration: Duration(seconds: 1),
                                                    //   showCloseIcon: true,
                                                    //   content: Text("Listeden çıkartıldı", style: GoogleFonts.aldrich(color: Colors.deepPurple),),
                                                    //   behavior: SnackBarBehavior.floating,
                                                    //   backgroundColor: Colors.deepPurple.shade100,
                                                    //   shape: StadiumBorder(),
                                                    //
                                                    // ) :  ScaffoldMessenger.of(context).showSnackBar(
                                                    //     SnackBar(
                                                    //       duration: Duration(seconds: 1),
                                                    //       showCloseIcon: true,
                                                    //       content: Text("Listeye eklendi", style: GoogleFonts.aldrich(color: Colors.deepPurple),),
                                                    //       behavior: SnackBarBehavior.floating,
                                                    //       backgroundColor: Colors.deepPurple.shade100,
                                                    //       shape: StadiumBorder(),
                                                    //
                                                    //     ));
                                                    // print(box.read("list"));

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
                        )),
                  ),
                ),


                floatingActionButton: FloatingActionButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Topics()));

                }, child: Icon(Icons.menu_book),),
              )




      ),
    );
  }
  _showModalSheet(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                          child: ListView.separated(itemBuilder: (BuildContext context, index){
                            return ListTile(
                              trailing: Image.asset("assets/book.png", filterQuality: FilterQuality.high, ),
                              title: Text(topics[index], style: GoogleFonts.aldrich(),),
                            );
                          },
                            separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                            },
                            itemCount: topics.length,

                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 6,
                          width: MediaQuery.of(context).size.width/9.5,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    )
                  ],
                );}
          );
        }
    );
  }

}