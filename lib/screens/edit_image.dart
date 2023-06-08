import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import '../utils/image_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditImage extends StatefulWidget {
  var index;
  final text;
  final link;
  final hero;
  final height;
  final size;
  final ImageModel data;

  EditImage(this.link, this.text, this.hero, this.height, this.data, this.size, this.index);

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  GlobalKey previewContainer = new GlobalKey();
  Color pickerColor = Color(0xffffffff);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
  double _fontSize = 18;
  double _blur = 0;
  Offset offset = Offset.zero;
  var _initStyle = GoogleFonts.poppins();

  @override
  void initState() {
    offset = Offset(0, 150);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        actions: [
          TextButton(onPressed: () async{
              setState(() {
                _isLoading = true;
              });
              await ShareFilesAndScreenshotWidgets().shareScreenshot(
                  previewContainer,
                  1200,
                  "Title",
                  "${widget.text.substring(0, 2)}.jpg",
                  "image/jpeg",
                  text: "www.gozelislam.com");

              setState(() {
                _isLoading = false;
              });}, child: Text("Paylaş", style: GoogleFonts.poppins(fontSize: 20 , fontWeight: FontWeight.bold )))
        ],
        centerTitle: true,
        title: Text("Düzenle", style: GoogleFonts.poppins(fontSize: 20 , fontWeight: FontWeight.bold )),
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.transparent,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RepaintBoundary(
              key: previewContainer,
              child: SizedBox(
                height: 350,
                child: Hero(
                  tag: widget.hero,
                  child: Stack(
                    children: [
                      Swiper(
                        onIndexChanged: (value){
                          setState(() {
                            widget.index = value;
                          });
                        },
                          index: widget.index,
                          itemCount: widget.data.hits.length,
                          itemBuilder:(context, index){
                            return
                              Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    image: DecorationImage(
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.fill,
                                        image: CachedNetworkImageProvider(widget.data.hits[index].largeImageUrl,)
                                    )
                                ),

                              );}
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Opacity(opacity: 1,
                              child: Padding(
                                  padding: EdgeInsets.all(8) ,
                                  child: Image.asset("assets/log.png", height: 60,)))),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Opacity(opacity: 1,
                              child: Padding(
                                  padding: EdgeInsets.all(5) ,
                                  child: Image.asset("assets/google.png", height: 50,)))),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Padding(
                      //       padding: const EdgeInsets.all(0.0),
                      //       child: AnimatedSize(duration: Duration(milliseconds: 300),
                      //       child: Text(widget.text, textAlign: TextAlign.center , style: GoogleFonts.poppins(fontSize: _fontSize, color: pickerColor, fontWeight: FontWeight.bold),))
                      //   ),
                      // ),
                      Container(
                        child: Positioned(
                          left: offset.dx,
                          top: offset.dy,
                          child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  offset = Offset(
                                      offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                                });
                              },
                              child: SizedBox(
                                width: size.width,
                                child: Center(
                                  child:Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: AnimatedSize(duration: Duration(milliseconds: 300),
                                    child:
                                    Text(
                                      widget.text,
                                      textAlign: TextAlign.center,
                                      style: _initStyle.copyWith(
                                        shadows: [Shadow(color: pickerColor, blurRadius: _blur)],
                                        fontSize: _fontSize, color: pickerColor,
                                          fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                                          ),)),
                                  ),),
                              )),
                        ),
                      ),
                      _isLoading ? Container(
                        child: Center(child: CircularProgressIndicator(color: Colors.white,)),
                        color: Colors.deepPurple.withOpacity(.8),
                      ) : SizedBox()
                    ],
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: Icon(Icons.font_download, color: Colors.deepPurple),
                  title: Text("Metin", style: GoogleFonts.alatsi(),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: (){
                        setState(() {
                          _fontSize--;
                        });
                      }, icon: Icon(Icons.remove, color: Colors.deepPurple)),
                      Text(_fontSize.toString(), style: GoogleFonts.alatsi(fontSize: 15),),
                      IconButton(onPressed: (){
                        setState(() {
                          _fontSize++;
                        });
                      }, icon: Icon(Icons.add, color: Colors.deepPurple,)),
                    ],
                  ),
                ),
                ListTile(
                  onTap: (){
                    _showModalSheet();
                  },
                    leading: Icon(Icons.color_lens_outlined, color: Colors.deepPurple),
                    title: Text("Renk", style: GoogleFonts.alatsi(),),
                    subtitle: Text(pickerColor.toString(),),
                    trailing:  Icon(Icons.colorize, color: Colors.deepPurple),
                ),
                ListTile(
                  onTap: (){
                    _selectFont();
                  },
                    leading: Icon(Icons.font_download_outlined, color: Colors.deepPurple),
                    title: Text("Font", style: GoogleFonts.alatsi(),),
                    subtitle: Text(_initStyle.fontFamily.toString(),),
                    trailing: Icon(Icons.chevron_right, color: Colors.deepPurple),
                ),
                ListTile(
                  leading: Icon(Icons.font_download_outlined, color: Colors.deepPurple),
                  title: Text("Font Style", style: GoogleFonts.alatsi(),),
                  trailing: ToggleButtons(
                    children: <Widget>[
                      Icon(Icons.format_bold),
                    ],
                    isSelected: _selections,
                    onPressed: (int index) {
                      setState(() {
                        _selections[index] = !_selections[index];
                         _bold  = _selections[0];
                      });
                    },
                  )
                ),

                ListTile(
                  leading: Icon(Icons.blur_circular, color: Colors.deepPurple),
                  title: Text("Parlaklık", style: GoogleFonts.alatsi(),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: (){
                        setState(() {
                          if(_blur>0){
                            _blur = _blur-1;
                          }else{
                          }
                        });
                      }, icon: Icon(Icons.remove, color: Colors.deepPurple)),
                      Text(_blur.toString(), style: GoogleFonts.alatsi(fontSize: 15),),
                      IconButton(onPressed: (){
                        setState(() {
                          _blur = _blur + 1;
                        });
                      }, icon: Icon(Icons.add, color: Colors.deepPurple,)),
                    ],
                  ),
                ),

              ],
            )
          ],
        ),
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
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                        pickerAreaBorderRadius: BorderRadius.circular(10),

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


  _selectFont(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStatse) {
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: ListView.builder(
                        itemCount: _fontList.length,
                          itemBuilder: (context, index){
                        return  ListTile(
                            onTap: (){
                            setState(() {
                              _initStyle = _fontList[index];
                            });
                            },
                            leading: Icon(Icons.font_download_outlined, color: Colors.deepPurple,),
                            title: Text(widget.text, maxLines: 1 , style: _fontList[index],),
                            subtitle: Text(_fontList[index].fontFamily.toString(),),
                            trailing:  Icon(Icons.chevron_right, color: Colors.deepPurple),
                        );
                      })

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

  var _bold = false;
  var _underlined = false;
  var _isLoading = false;
  List<bool> _selections = List.generate(1, (_)=> false);
  var _fontList = [
    GoogleFonts.roboto(),
    GoogleFonts.openSans(),
    GoogleFonts.poppins(),
    GoogleFonts.robotoCondensed(),
    GoogleFonts.inter(),
    GoogleFonts.robotoSlab(),
    GoogleFonts.nunito(),
    GoogleFonts.playfairDisplay(),
    GoogleFonts.kanit(),
    GoogleFonts.josefinSans(),
    GoogleFonts.libreBaskerville(),
    GoogleFonts.noticiaText(),
    GoogleFonts.spaceMono(),
    GoogleFonts.lexendDeca(),
    GoogleFonts.arima(),
  ];
}