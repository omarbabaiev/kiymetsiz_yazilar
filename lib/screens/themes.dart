import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:voca_voca/screens/home_screen.dart';
import 'package:voca_voca/utils/theme_model.dart';
import '../book/book.dart';
import '../utils/image_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_image.dart';
import 'package:lottie/lottie.dart';
import 'package:get_storage/get_storage.dart';
class SelectTheme extends StatefulWidget {
  @override
  State<SelectTheme> createState() => _SelectThemeState();
}

class _SelectThemeState extends State<SelectTheme> {
  int? selectedItem;
  GetStorage box = GetStorage();

   @override
  void initState() {
     selectedItem = box.read("theme")??0;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(20)

        ),
        child:
        // Scaffold(
        //   backgroundColor: Colors.transparent,
        //   extendBodyBehindAppBar: true,
        //   appBar: AppBar(
        //     centerTitle: true,
        //     title: Text("Temalar", style: GoogleFonts.poppins(fontSize: 20 , fontWeight: FontWeight.bold )),
        //     scrolledUnderElevation: 0,
        //     shadowColor: Colors.transparent,
        //     elevation: 0,
        //     backgroundColor: Colors.transparent,
        //     leading: SizedBox(),
        //     actions: [
        //      selectedItem == null ? SizedBox() :
        //      Animate(effects: [FadeEffect(), ScaleEffect()],
        //      child: TextButton(onPressed: (){
        //        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen( box.read("allOfBook")?? kiymetsizYazilar[0])));
        //      }, child: Text("Seç", style: GoogleFonts.poppins(fontSize: 20 , fontWeight: FontWeight.bold, ))))
        //     ],
        //   ),
        //
        //
        //   body:

          Animate(
              effects: [FadeEffect(), ScaleEffect()],
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
                  Text('Temalar', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 25),),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 20, top: 20),
                        itemCount: themes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: .6),
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: () {
                              setState(() {
                                box.write("theme", index);
                                selectedItem = index;
                              });
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen( box.read("allOfBook")?? kiymetsizYazilar[0])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedContainer(
                                    child: Center(
                                      child: Text("ABCD", style: themes[index].style.copyWith(color: themes[index].appBarTextColor),),
                                    ),
                                    height: 200,
                                    width: 120,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: AssetImage("assets/${themes[index].photo}.jpg"), fit: BoxFit.fill),
                          border: selectedItem == index ? Border.all(
                                  width: 4,
                                  color: Color(0xFF1E11DE) ) : Border.all(
                                          width: 0,
                                          color: Color(0xFF1E11DE)) ,
                                    ), duration: Duration(milliseconds: 300),
                                  ),
                                  selectedItem == index ?  Align(
                                    alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Animate(
                                            effects: [FadeEffect(), ScaleEffect()],
                                            child: Icon(Icons.check_circle_outline, color: Colors.purpleAccent,)),
                                      )): SizedBox()
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              )
          ),
        // )




    );
  }
}
