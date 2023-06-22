
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:voca_voca/book/book.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voca_voca/screens/home_screen.dart';

import '../book/topics.dart';


class Topics extends StatefulWidget {

  @override
  State<Topics> createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
  var item = 0;
  GetStorage box = GetStorage();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,

          ),
          child:
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Başlıklar", style: GoogleFonts.poppins(fontSize: 20 , fontWeight: FontWeight.bold )),
              scrolledUnderElevation: 0,
              shadowColor: Colors.transparent,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [

              ],
            ),


            body: Animate(
              effects: [FadeEffect(), ScaleEffect()],
              child: GridView.builder(
                padding: EdgeInsets.only(bottom: 20, top: 100),
                itemCount: topics.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: ()async{
                      await box.write("allOfBook", kiymetsizYazilar[index]);
                      await box.write("topic", topics[index]);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(box.read("allOfBook"))));
                    },
                    child: Container(
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(topics[index], textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),

                        ],
                      )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2, color: Colors.deepPurple)
                      ),
                    ),
                  ),
                );
                  })
            ),
          )




      ),
    );
  }
}