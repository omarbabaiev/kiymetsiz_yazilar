import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:voca_voca/screens/privacy_policy.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
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
import 'package:voca_voca/screens/background.dart';
import 'package:voca_voca/screens/book_info.dart';
import 'package:voca_voca/screens/favorite_list.dart';
import 'package:voca_voca/screens/themes.dart';
import 'package:voca_voca/screens/topics.dart';
import '../book/topics.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

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


  void _launchUrl(String patha) async {
    if (!await launch(Uri.parse(patha).toString(), forceSafariVC: true, forceWebView: false )) throw 'Could not launch $patha';
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
                drawer: Drawer(
                  backgroundColor: Colors.deepPurple.shade100,
                  child: ListView(
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/drawers.png"), fit: BoxFit.fill, opacity: .3),
                          color: Colors.deepPurple.shade100
                        ), child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Image.asset("assets/book.png"), flex: 1,),
                          Expanded(child: ListTile(
                            title: Text("Kıymetsiz Yazılar", style: GoogleFonts.alata(fontSize: 20, fontWeight: FontWeight.bold),),
                            subtitle: Text("Hüseyin Hilmi İşık", style: GoogleFonts.alata()),), flex: 2,)
                        ],
                      ),
                      ),
                      ListTile(
                        onTap: ()async {
                          VocsyEpub.setConfig(
                            themeColor: Theme.of(context).primaryColor,
                            identifier: "iosBook",
                            scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                            allowSharing: true,
                            enableTts: true,
                            nightMode: false,
                          );
                          // get current locator
                          VocsyEpub.locatorStream.listen((locator) {
                            print('LOCATOR: $locator');
                          });
                          await VocsyEpub.openAsset(
                            'assets/book.epub',
                            lastLocation: EpubLocator.fromJson({
                              "bookId": "2239",
                              "href": "/OEBPS/ch06.xhtml",
                              "created": 1539934158390,
                              "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
                            }),
                          );
                        },
                        leading: Icon(Icons.chrome_reader_mode_outlined, color: Colors.deepPurple,),
                        title: Text("Oku", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      ListTile(
                        onTap: (){
                          _selectTopic();
                        },
                        leading: Icon(Icons.topic, color: Colors.deepPurple,),
                        title: Text("Başlıklar", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=>Favorite()));
                        },
                        leading: Icon(Icons.favorite_border, color: Colors.deepPurple,),
                        title: Text("Sonra okunacaklar listesi", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      ListTile(
                        onTap: (){
                          _selectTheme();
                        },
                        leading: Icon(Icons.interests_outlined, color: Colors.deepPurple,),
                        title: Text("Tema seç", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          thickness: 2,
                          color: Colors.deepPurple,
                        ),
                      ),
                      ListTile(
                        onTap: (){
                          _launchUrl("https://www.gozelislam.com/book/");
                        },
                        leading: Icon(Icons.book_outlined, color: Colors.deepPurple,),
                        title: Text("Diğer kitaplar", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BookInfoScreen()));
                        },
                        leading: Icon(Icons.info_outline, color: Colors.deepPurple,),
                        title: Text("Kitap hakkında bilgi", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));
                        },
                        leading: Icon(Icons.privacy_tip_outlined, color: Colors.deepPurple,),
                        title: Text("Privacy policy", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      ListTile(
                        onTap: (){
                          if (Platform.isAndroid || Platform.isIOS) {
                            final appId = Platform.isAndroid ? "com.lezgindev.kiymetsiz_yazilar" : 'YOUR_IOS_APP_ID';
                            final url = Uri.parse(
                              Platform.isAndroid
                                  ? "market://details?id=$appId"
                                  : "https://apps.apple.com/app/id$appId",
                            );
                            launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        leading: Icon(Icons.star_rate_outlined, color: Colors.deepPurple,),
                        title: Text("Uygulamayı deyerlendir", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      ListTile(
                        onTap: ()async{
                          await Share.share("${"Dini Mövzular, Söhbətlər və Sual-Cavab\n com.lezgindev.kiymetsiz_yazilar"}");
                        },
                        leading: Icon(Icons.share, color: Colors.deepPurple,),
                        title: Text("Paylaş", style: GoogleFonts.alata(fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          thickness: 2,
                          color: Colors.deepPurple,
                        ),
                      ),
                      ListTile(
                        title: Text("Version", textAlign: TextAlign.center,  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                        subtitle: Text("1.0.0", textAlign: TextAlign.center, style: GoogleFonts.poppins(),),
                      ),


                    ],
                  ),
                ),
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
                    IconButton(onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (context)=>Favorite()));}, icon: Icon(Icons.favorite_border, )),
                    IconButton(onPressed: (){
                      _selectTheme();
                   }, icon: Icon(Icons.interests, )),]),


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
                                                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>BackgroundScreen(bookContent[index])));
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
                  _selectTopic();
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Topics()));
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Topics()));


                }, label: Text(box.read("topic")??"A, E, İ, Ü", style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.bold ), ),),
              )




      ),
    );
  }
  _selectTopic(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStatse) {
                return Topics();}
          );
        }
    );
  }
  _selectTheme(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStatse) {
                return SelectTheme();}
          );
        }
    );
  }



}