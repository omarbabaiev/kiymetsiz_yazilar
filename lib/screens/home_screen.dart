
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca_voca/book/book.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voca_voca/screens/background.dart';
import 'package:voca_voca/screens/book_info.dart';
import 'package:voca_voca/screens/favorite_list.dart';
import 'package:voca_voca/screens/themes.dart';
import '../book/topics.dart';
import '../utils/theme_model.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';


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
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            opacity: .4,
                            fit: BoxFit.fill,
                              image: AssetImage("assets/drawers.png")

                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: Image.asset("assets/book.png", )),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: ListTile(
                                  title: Text("Kıymetsiz yazılar", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),),
                                  subtitle: Text("Hüseyn Hilmi Işık", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400)),
                                ),
                              ),
                            )
                          ],
                        ),
                          ),
                      ListTile(
                        onTap: ()async {
                          VocsyEpub.setConfig(
                            themeColor: Theme.of(context).primaryColor,
                            identifier: "iosBook",
                            scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                            allowSharing: false,
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
                        title: Text("Oku", style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        leading: Icon(Icons.chrome_reader_mode_outlined, color: Colors.deepPurple,),
                      ),
                      ListTile(
                        onTap: (){
                          _showTopics(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectTheme()));
                        },
                        title: Text("Başlıklar", style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        leading: Icon(Icons.topic, color: Colors.deepPurple,),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=>Favorite()));
                        },
                        title: Text("Sonra okunacaklar listesi", style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        leading: Icon(Icons.favorite_border, color: Colors.deepPurple,),
                      ),
                      ListTile(
                        onTap: (){
                            _showThemes(context);// Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectTheme()));
                        },
                        title: Text("Tema seç", style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        leading: Icon(Icons.interests, color: Colors.deepPurple,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(color: Colors.deepPurple,),
                      ),


                      ListTile(
                        onTap: (){
                          _launchUrl("http://www.hakikatkitabevi.net/?listBook=tr");
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectTheme()));
                        },
                        title: Text("Diğer kitaplar", style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        leading: Icon(Icons.book_outlined, color: Colors.deepPurple,),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=>BookInfoScreen()));
                        },
                        title: Text("Kitap hakkında bilgi", style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        leading: Icon(Icons.perm_device_info_sharp, color: Colors.deepPurple,),
                      ),
                      ListTile(
                        onTap: (){
                          if (Platform.isAndroid || Platform.isIOS) {
                            final appId = Platform.isAndroid ? 'com.prayer_time_gi.app&pli=1' : 'YOUR_IOS_APP_ID';
                            final url = Uri.parse(
                              Platform.isAndroid
                                  ? "market://details?id=$appId"
                                  : "https://apps.apple.com/app/id$appId",);
                            launchUrl(url, mode: LaunchMode.externalApplication,);}
                        },
                        title: Text("Uygulamayı deyerlendir", style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        leading: Icon(Icons.star_rate_outlined, color: Colors.deepPurple,),
                      ),
                      ListTile(
                        onTap: (){
                          Share.share('https://play.google.com/store/apps/details?id=com.prayer_time_gi.app&pli=1', );
                        },
                        title: Text("Paylaş", style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        leading: Icon(Icons.share, color: Colors.deepPurple,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(color: Colors.deepPurple,),
                      ),
                      ListTile(
                        onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectTheme()));
                        },
                        title: Text("Version", textAlign: TextAlign.center, style: GoogleFonts.poppins( fontWeight: FontWeight.w600),),
                        subtitle: Text("1.0.0", textAlign: TextAlign.center,),
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
                      _showThemes(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectTheme()));
                      }, icon: Icon(Icons.interests, )),


                  ]),


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
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Topics()));
                  _showTopics(context);


                }, label: Text(box.read("topic")??"A, E, İ, Ü", style: GoogleFonts.poppins(fontSize: 15 , fontWeight: FontWeight.bold ), ),),
              )




      ),
    );
  }
  void _showTopics(BuildContext context) {
    var item = 0;
    GetStorage box = GetStorage();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return
          Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20)
              ),
              child:   Animate(
                  effects: [FadeEffect(), ScaleEffect()],
                  child: Scrollbar(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 10,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepPurple
                            ),
                          ),
                        ),
                        Text('Başlıklar', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25),),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 20, top: 20),
                              itemCount: topics.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                              itemBuilder: (context, index){
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: ()async{
                                      await box.write("allOfBook", kiymetsizYazilar[index]);
                                      await box.write("topic", topics[index]);
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(box.read("allOfBook"))));
                                    },
                                    child: Container(
                                      child: Center(child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(topics[index], textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),),

                                        ],
                                      )),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(width: 2, color: Colors.deepPurple)
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  )
              ),






          );}
        ));
  }
  void _showThemes(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        context: context,
        builder: (ctx) =>SelectTheme());
  }


}