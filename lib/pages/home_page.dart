import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friday/model/radio.dart';
import 'package:friday/utilis/ai_utilis.dart';
import 'package:velocity_x/velocity_x.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<MyRadio> radios;
  MyRadio _selectedRadio;
  Color _selectedColor;
  bool _isplaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
     if(event == AudioPlayerState.PLAYING) {
       _isplaying = true;
     }else{_isplaying = false;}
     setState(() {
     });
    });
  }
  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    print(radios);
    setState(() {

    });
  }
  _playMusic(String url){
    _audioPlayer.play(url);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    print(_selectedRadio.name);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        VxAnimatedBox().size(context. screenWidth,context. screenHeight)
            .withGradient(LinearGradient(colors: [
            AIColors.primaryColor1,
            _selectedColor ??
            AIColors.primaryColor2,
          ],begin: Alignment.topLeft,end: Alignment.bottomRight),
        )
        .make(),
        AppBar(
          title: "Friday".text.xl4.bold.black.make().shimmer(
            primaryColor: Colors.black,
            secondaryColor: Colors.grey,
          ),
           backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ).h(100.0).p16(),
        radios!=null? VxSwiper.builder(itemCount: radios.length,aspectRatio: 1.0,
          enlargeCenterPage: true ,
          onPageChanged: (index) {final colorHex = radios[index].color;
          _selectedColor = Color(int.tryParse(colorHex));
          setState(() {
          });
          },
            itemBuilder: (context, index){
          final rad = radios[index];
          return VxBox(
            child: ZStack([
              Positioned(
                top: 0.0,
                right: 0.0,
                child: VxBox(
                child: rad.category.text.white.make().px16(),).height(40).red600.
                alignCenter.withRounded(value: 10.0).make(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: VStack([
                  rad.name.text.xl3.white.bold.make(),
                  5.heightBox,
                  rad.tagline.text.sm.white.semiBold.make(),
                ]),
              ),
              Align(
                alignment: Alignment.center,
                child: [Icon(CupertinoIcons.play_circle,
                color: Colors.white,
                  size: 70.0,
            ),
            10.heightBox,
                  "Tap to play".text.gray300.make(),
            ].vStack()
            )
            ],
            ))
          .clip(Clip.antiAlias)
              .bgImage(DecorationImage(image: NetworkImage(rad.image),
          fit: BoxFit.cover,colorFilter: ColorFilter.mode
                (Colors.black.withOpacity(0.3),BlendMode.darken)))
              .border(color: Colors.black54,width: 5.0)
              .withRounded(value: 60.0).make().onTap(() {
                _playMusic(rad.url);
          }).p16();
        },
        ).centered():Center(child: CircularProgressIndicator(backgroundColor: Colors.black26,),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: [
            if(_isplaying)
              "playing now - ${_selectedRadio.name} FM".text.white.makeCentered(),
            Icon(
            _isplaying ? CupertinoIcons.stop_circle
                : CupertinoIcons.play_circle,color: Colors.white ,size: 70.0,).onInkTap(() {
                  if(_isplaying){_audioPlayer.stop();} else {_playMusic(_selectedRadio.url);}
            })
          ].vStack(),
        ).pOnly(bottom: context.percentHeight * 12)
       ],
        fit: StackFit.expand,
      ),
    );
  }
}
