
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/theme_model.dart';
import 'package:share_plus/share_plus.dart';

class BookInfoScreen extends StatelessWidget {
  GetStorage box = GetStorage();

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
            appBar: AppBar(
              centerTitle: true,
              title: Text("Kitap hakkında bilgi", style: GoogleFonts.aldrich(fontSize: 20 , fontWeight: FontWeight.bold, color: themes[box.read("theme")??0].appBarTextColor )),
              scrolledUnderElevation: 0,
              shadowColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: themes[box.read("theme")??0].appBarIconColor),
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(onPressed: (){
                  Share.share('https://play.google.com/store/apps/details?id=com.prayer_time_gi.app&pli=1', );
                }, icon: Icon(Icons.share, ))
              ],
            ),


            body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Animate(
                  effects: [ FadeEffect(duration: Duration(milliseconds: 500))],
                    child:
                    Align(
                      alignment: Alignment.topCenter,
                        child: Image.asset("assets/book.png", height: 150,)),
                ),
                    Animate(
                      effects: [ FadeEffect(duration: Duration(milliseconds: 1200))],
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("İmâm-ı Rabbânî Müceddîd-i Elf-i sânî Ahmed Fârûkî Serhendi hazretlerinin üç cild (MEKTÛBÂT) kitâbından ve oğulları Muhammed Ma’sûm-i Fârûkî hazretlerinin de üç cild (MEKTÛBÂT) kitâbından, çıkarılan kıymetli cümleler, Elif-ba sırasına göre tanzîm edilmiş, Seyyid Abdülhakîm Arvâsî hazretlerine okunmuşdur. Dikkat ile dinledikden sonra, bunun adı (Kıymetsiz Yazılar) olsun demişdir. Okuyanın hayreti üzere, anlamadın mı, (Bunun kıymetine karşılık olabilecek birşey bulunabilir mi?) buyurmuşdur. Son sayfasında şu cümleler yer almakdadır:",
                            style: themes[box.read("theme")??0].style.copyWith(fontSize: 18), textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Animate(
                      effects: [FadeEffect(duration: Duration(milliseconds: 1500))],
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("""(Fırsat ganîmetdir. Ömrün temâmını fâidesiz işlerle telef ve sarf etmemek lâzımdır. Belki temâm ömrü, Hak celle ve a’lânın rızâsına muvâfık ve mutâbık şeylere sarf etmek lâzımdır...)""",
                          style: themes[box.read("theme")??0].style.copyWith(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.justify,
                        ),
                      ),
                    ),


                  ]
              ),
            ),
          )




      ),
    );
  }
}