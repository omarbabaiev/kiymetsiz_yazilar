import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/image_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_image.dart';
import 'package:lottie/lottie.dart';


class BackgroundScreen extends StatefulWidget {
  String text;

  BackgroundScreen(this.text);

  @override
  State<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends State<BackgroundScreen> {

var _api = "26288319-44b0e3d8845c3bd82f251f7a9&q";

Future<ImageModel>_fetchData()async{
  var response = await http.get(Uri.parse("https://pixabay.com/api/?key=${_api}=night+background&image_type=photo&orientation=horizontal&colors=blue&per_page=200"));
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
              title: Text("Arka plan seç", style: GoogleFonts.poppins(fontSize: 20 , fontWeight: FontWeight.bold )),
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
                       return Center(child: Lottie.asset("assets/lottie.json", height: 100),);
                     } else if(snapshot.connectionState == ConnectionState.done){
                       if(snapshot.hasData){
                         return  Scrollbar(
                           child: GridView.builder(
                               padding: EdgeInsets.only(bottom: 20, top: 100),
                               itemCount: snapshot.data!.hits.length,
                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.3),
                               itemBuilder: (context, index){
                                 return Padding(
                                     padding: const EdgeInsets.all(4.0),
                                     child: InkWell(
                                         onTap: (){
                                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                               EditImage( snapshot.data!.hits[index].largeImageUrl, widget.text, "${index}", snapshot.data!.hits[index].imageHeight.toDouble(), snapshot.data!, snapshot.data!.hits[index].imageSize, index)));
                                         },
                                         child: Hero(tag: "${index}",
                                         child: Container(
                                           height: 200,
                                           child: ClipRRect(
                                             borderRadius: BorderRadius.circular(10),
                                             child: CachedNetworkImage(
                                               fit: BoxFit.fill,
                                               placeholder: (context, String){
                                                 return Image.asset("assets/log.png");
                                             },
                                               imageUrl: snapshot.data!.hits[index].previewUrl,),
                                           ),
                                         )))
                                 );
                               }),
                         );
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



