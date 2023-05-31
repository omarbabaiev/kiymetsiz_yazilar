import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:voca_voca/book/book.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

import '../book/topics.dart';
import '../utils/image_model.dart';


class BackgroundScreen extends StatefulWidget {
  String text;

  BackgroundScreen(this.text);

  @override
  State<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends State<BackgroundScreen> {

var _api = "26288319-44b0e3d8845c3bd82f251f7a9&q";

Future<ImageModel>_fetchData()async{
  var response = await http.get(Uri.parse("https://pixabay.com/api/?key=${_api}=nature+islamic&image_type=photo&orientation=horizontal&colors=blue"));
  var data = imageModelFromJson(response.body);
  return data;
}



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
            // image: DecorationImage(image: AssetImage("assets/back2.jpg"),
            //   fit: BoxFit.cover,
            //   colorFilter: ColorFilter.mode(Colors.deepPurpleAccent, BlendMode.overlay))
          ),
          child:
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Arka plan seç", style: GoogleFonts.aldrich(fontSize: 20 , fontWeight: FontWeight.bold )),
              scrolledUnderElevation: 0,
              shadowColor: Colors.transparent,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [

              ],
            ),


            body: Animate(
                effects: [FadeEffect(), ScaleEffect()],
                child: FutureBuilder(
                  future: _fetchData(),
                  builder: (BuildContext context, AsyncSnapshot<ImageModel> snapshot) {
                     if(snapshot.connectionState == ConnectionState.waiting){
                       return Center(child: CircularProgressIndicator(),);
                     } else if(snapshot.connectionState == ConnectionState.done){
                       if(snapshot.hasData){
                         return  GridView.builder(
                             padding: EdgeInsets.only(bottom: 20, top: 100),
                             itemCount: snapshot.data!.hits.length,
                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                             itemBuilder: (context, index){
                               return Padding(
                                   padding: const EdgeInsets.all(4.0),
                                   child: InkWell(
                                       onTap: (){
                                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditImage( snapshot.data!.hits[index].largeImageUrl, widget.text,)));
                                       },
                                       child: Image.network(snapshot.data!.hits[index].previewUrl))
                               );
                             });
                       }else{
                         Center(child: Text(snapshot.error.toString()),);
                       }
                     }
                     return Center(child: Text("sasa"),);
                  },
                )
            ),
          )




      ),
    );
  }
}


class EditImage extends StatelessWidget {
  GlobalKey previewContainer = new GlobalKey();
  final text;
  final link;

  EditImage(this.link, this.text);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Share", style: GoogleFonts.aldrich(fontSize: 20 , fontWeight: FontWeight.bold )),
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.transparent,),
      body: RepaintBoundary(
        key: previewContainer,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
                child: Image.network(link, fit: BoxFit.cover,)
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(text, textAlign: TextAlign.center , maxLines: 9, style: GoogleFonts.aldrich(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),)
              ),
            ),

          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(onPressed: () async{
      await ShareFilesAndScreenshotWidgets().shareScreenshot(
          previewContainer,
          60000,
          "Title",
          "${text.substring(0, 10)}.png",
          "image/png",
          text: "This is the caption!");

    }, child: Text("Share"),),
    );
  }
}
